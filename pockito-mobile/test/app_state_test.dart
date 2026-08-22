import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/app/pockito_app_state.dart';
import 'package:pockito/data/pockito_exception.dart';
import 'package:pockito/domain/pockito_models.dart';

import 'fakes.dart';

/// The app routes purely from [AppStage], so these transitions are the whole
/// contract for what a user can reach. Getting one wrong means either locking a
/// user out or letting them past a step they have not completed.
void main() {
  group('start-up', () {
    test('with no stored session, goes to Welcome', () async {
      final auth = FakeAuthService(storedSession: false);
      final api = FakeApi();
      final state = buildState(auth: auth, api: api);

      await state.start();

      expect(state.stage, AppStage.loggedOut);
      expect(api.bootstrapCalls, 0, reason: 'no session means nothing to fetch');
    });

    test('with a stored session and onboarding outstanding, goes to onboarding', () async {
      final state = buildState(
        auth: FakeAuthService(storedSession: true),
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: true)),
      );

      await state.start();

      expect(state.stage, AppStage.onboarding);
    });

    test('with a stored session and onboarding done, goes to Home', () async {
      final state = buildState(
        auth: FakeAuthService(storedSession: true),
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false)),
      );

      await state.start();

      expect(state.stage, AppStage.ready);
      expect(state.profile?.displayName, 'Kito Tester');
    });

    test('applies cached preferences before the network answers', () async {
      final cache = FakeCache()
        ..stored = const Preferences(
          theme: AppTheme.dark,
          language: AppLanguage.ja,
          defaultCurrency: 'JPY',
        );
      final state = buildState(auth: FakeAuthService(storedSession: false), cache: cache);

      var themeAtFirstNotification = AppTheme.system;
      state.addListener(() {
        themeAtFirstNotification = state.preferences.theme;
      });
      await state.start();

      // Without this the app opens white for a user who chose Dark.
      expect(themeAtFirstNotification, AppTheme.dark);
    });

    test('a refresh token Keycloak rejects lands on Welcome, not a retry loop', () async {
      final state = buildState(auth: FakeAuthService(storedSession: false));
      await state.start();
      expect(state.stage, AppStage.loggedOut);
    });
  });

  group('signing in', () {
    test('a new account goes to onboarding', () async {
      final auth = FakeAuthService(storedSession: false);
      final state = buildState(
        auth: auth,
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: true)),
      );
      await state.start();
      expect(state.stage, AppStage.loggedOut);

      await state.signIn();

      expect(state.stage, AppStage.onboarding);
    });

    test('a returning account goes straight to Home', () async {
      final state = buildState(
        auth: FakeAuthService(storedSession: false),
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false)),
      );
      await state.start();

      await state.signIn();

      expect(state.stage, AppStage.ready);
    });

    test('asks Keycloak for registration when the user chose Create account', () async {
      final auth = FakeAuthService(storedSession: false);
      final state = buildState(auth: auth);
      await state.start();

      await state.signIn(register: true);

      expect(auth.registerRequested, isTrue);
    });

    test('a cancelled sign-in leaves the user on Welcome without an error', () async {
      final auth = FakeAuthService(storedSession: false, signInSucceeds: false);
      final state = buildState(auth: auth);
      await state.start();

      final result = await state.signIn();

      expect(result, isFalse);
      expect(state.stage, AppStage.loggedOut);
      expect(state.failure, isNull, reason: 'backing out is a choice, not a failure');
    });
  });

  group('onboarding', () {
    test('completing it moves the user to Home and keeps their answers', () async {
      final api = FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: true));
      final state = buildState(auth: FakeAuthService(storedSession: true), api: api);
      await state.start();
      expect(state.stage, AppStage.onboarding);

      await state.completeOnboarding(
        displayName: '  Kito Tester  ',
        preferences: const Preferences(
          language: AppLanguage.ja,
          theme: AppTheme.dark,
          defaultCurrency: 'JPY',
        ),
      );

      expect(state.stage, AppStage.ready);
      expect(api.lastDisplayName, 'Kito Tester', reason: 'the name is trimmed before saving');
      expect(state.preferences.defaultCurrency, 'JPY');
      expect(state.profile?.onboardingCompleted, isTrue);
    });

    test('a rejected submission leaves the user in onboarding', () async {
      final api = FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: true));
      final state = buildState(auth: FakeAuthService(storedSession: true), api: api);
      await state.start();

      // The failure has to arrive at submission time, not at start-up: this is
      // about a rejected answer, not an outage.
      api.failure = const PockitoException(
        'preferences.currency.unsupported',
        'unsupported',
        status: 400,
      );
      await expectLater(
        state.completeOnboarding(displayName: 'Kito', preferences: const Preferences()),
        throwsA(isA<PockitoException>()),
      );

      expect(state.stage, AppStage.onboarding);
    });
  });

  group('signing out', () {
    test('returns to Welcome and forgets the profile and preferences', () async {
      final auth = FakeAuthService(storedSession: true);
      final cache = FakeCache();
      final state = buildState(
        auth: auth,
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false)),
        cache: cache,
      );
      await state.start();
      expect(state.stage, AppStage.ready);

      await state.signOut();

      expect(state.stage, AppStage.loggedOut);
      expect(state.profile, isNull);
      expect(auth.signedOutRemotely, isTrue, reason: 'the Keycloak session ends too');
      expect(cache.stored, isNull, reason: 'nothing about the user is left on the device');
    });

    test('signing in again returns to Home', () async {
      final auth = FakeAuthService(storedSession: true);
      final state = buildState(
        auth: auth,
        api: FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false)),
      );
      await state.start();
      await state.signOut();

      await state.signIn();

      expect(state.stage, AppStage.ready);
    });
  });

  group('failures', () {
    test('an expired session sends the user back to Welcome', () async {
      final auth = FakeAuthService(storedSession: true);
      final api = FakeApi()..failure = const PockitoException.unauthenticated();
      final state = buildState(auth: auth, api: api);

      await state.start();

      expect(state.stage, AppStage.loggedOut);
      expect(auth.signedOutLocally, isTrue);
    });

    test('an unreachable backend is its own state, not a guess at Home', () async {
      final api = FakeApi()..failure = const PockitoException.offline();
      final state = buildState(auth: FakeAuthService(storedSession: true), api: api);

      await state.start();

      expect(state.stage, AppStage.unavailable);
      expect(state.failure?.code, 'network.unreachable');
    });

    test('retrying after an outage recovers without signing in again', () async {
      final auth = FakeAuthService(storedSession: true);
      final api = FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false))
        ..failure = const PockitoException.offline();
      final state = buildState(auth: auth, api: api);
      await state.start();
      expect(state.stage, AppStage.unavailable);

      api.failure = null;
      await state.retry();

      expect(state.stage, AppStage.ready);
      expect(auth.signInCalls, 0, reason: 'an outage is not a reason to re-authenticate');
    });
  });

  group('profile and preferences', () {
    test('preferences roll back when the server rejects them', () async {
      final api = FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false));
      final state = buildState(auth: FakeAuthService(storedSession: true), api: api);
      await state.start();
      final original = state.preferences;

      api.failure = const PockitoException(
        'preferences.currency.unsupported',
        'unsupported',
        status: 400,
      );
      await expectLater(
        state.updatePreferences(original.copyWith(defaultCurrency: 'ZZZ')),
        throwsA(isA<PockitoException>()),
      );

      expect(state.preferences.defaultCurrency, original.defaultCurrency,
          reason: 'the UI must not keep showing a setting that was not saved');
    });

    test('uploading an avatar refetches the pre-signed URL', () async {
      final api = FakeApi(bootstrap: FakeApi.defaultBootstrap(onboardingRequired: false));
      final state = buildState(auth: FakeAuthService(storedSession: true), api: api);
      await state.start();

      await state.uploadAvatar(bytes: const [1, 2, 3], filename: 'a.png', contentType: 'image/png');

      expect(api.lastAvatarBytes, const [1, 2, 3]);
      expect(state.profile?.avatarUrl, isNotNull);
    });
  });
}
