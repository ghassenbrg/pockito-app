import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

/// Sections 5.1–5.8 and 9.2: the token layer itself.
///
/// These assertions are deliberately literal. The audit fixes exact values, and
/// a token that quietly drifts back up a tier is the failure mode the whole
/// programme exists to prevent — so the numbers are restated here rather than
/// read from the same constants they are meant to police.
void main() {
  group('typography (5.1)', () {
    for (final theme in [PkTheme.light(), PkTheme.dark()]) {
      final type = theme.extension<PkTypography>()!;
      final name = theme.brightness.name;

      test('the semantic scale holds its sizes in $name', () {
        expect(type.moneyHero.fontSize, 32);
        expect(type.moneyInput.fontSize, 32);
        expect(type.moneySection.fontSize, 24);
        expect(type.moneyRow.fontSize, 15);
        expect(type.screenTitle.fontSize, 24);
        expect(type.appBarTitle.fontSize, 18);
        expect(type.sectionTitle.fontSize, 18);
        expect(type.rowTitle.fontSize, 15);
        expect(type.body.fontSize, 15);
        expect(type.bodyStrong.fontSize, 15);
        expect(type.supporting.fontSize, 13);
        expect(type.label.fontSize, 12);
        expect(type.micro.fontSize, 11);
      });

      test('every style uses tabular figures in $name', () {
        // Section 5.1: monetary, percentage, date and count columns have to
        // align, and the simplest way to guarantee that is one family setting.
        for (final style in [
          type.moneyHero,
          type.moneyInput,
          type.moneySection,
          type.moneyRow,
          type.rowTitle,
          type.supporting,
          type.label,
        ]) {
          expect(
            style.fontFeatures?.map((f) => f.feature),
            contains('tnum'),
            reason: 'A money-adjacent style lost tabular figures in $name',
          );
        }
      });

      test('one family across the scale in $name', () {
        final families = {
          type.moneyHero.fontFamily,
          type.screenTitle.fontFamily,
          type.body.fontFamily,
          type.micro.fontFamily,
        };
        expect(families, hasLength(1));
      });
    }
  });

  group('spacing, radius and size (5.2, 5.3, 5.5)', () {
    test('the section gap comes down from 24 to 20', () {
      expect(PkSpacing.section, 20);
      expect(PkSpacing.screen, 16);
      expect(PkSpacing.screenNarrow, 12);
      expect(PkSpacing.headerToContent, 12);
    });

    test('routine cards are 16, heroes 20, sheets 24', () {
      expect(PkRadius.small, 8);
      expect(PkRadius.control, 12);
      expect(PkRadius.card, 16);
      expect(PkRadius.hero, 20);
      expect(PkRadius.sheet, 24);
      // The legacy names now resolve onto the same scale, so a screen that
      // still says `extraLarge` cannot land outside the system.
      expect(PkRadius.large, PkRadius.card);
      expect(PkRadius.extraLarge, PkRadius.hero);
      expect(PkRadius.modal, PkRadius.sheet);
    });

    test('the cross-platform touch floor is 48', () {
      expect(PkSize.touch, 48);
      expect(PkSize.navTarget, greaterThanOrEqualTo(48));
    });

    test('row contracts are named, not improvised', () {
      expect(PkSize.rowSimple, 56);
      expect(PkSize.rowStandard, 64);
      expect(PkSize.rowRich, 72);
      expect(PkSize.rowStatus, 80);
    });

    test('visible controls are smaller than their targets', () {
      for (final visible in [
        PkSize.iconTileDense,
        PkSize.iconTileFeature,
        PkSize.avatarCompact,
        PkSize.avatarMember,
        PkSize.chip,
        PkSize.buttonCompact,
        PkSize.tabs,
      ]) {
        expect(
          visible,
          lessThan(PkSize.touch),
          reason: 'A visible control is as large as the target around it',
        );
      }
      expect(PkSize.button, PkSize.touch);
      expect(PkSize.buttonFinal, 52);
    });
  });

  group('breakpoints and widths (5.8)', () {
    test('the named thresholds exist', () {
      expect(PkBreakpoints.compactNarrow, 360);
      expect(PkBreakpoints.compact, 600);
      expect(PkBreakpoints.medium, 840);
      expect(PkBreakpoints.navigationRail, 900);
      expect(PkBreakpoints.expanded, 1180);
    });

    test('content widths are semantic, not one 760 column', () {
      expect(PkBreakpoints.formMaxWidth, 560);
      expect(PkBreakpoints.readingMaxWidth, 640);
      expect(PkBreakpoints.dashboardMaxWidth, 1120);
      expect(
        PkBreakpoints.readingMaxWidth,
        lessThan(PkSize.contentMaxWidth),
        reason: '760 was too wide for body copy; reading measure must be less',
      );
    });
  });

  group('elevation (5.4)', () {
    test(
      'a raised card lifts less than a hero, and a hero less than before',
      () {
        final card = PkShadows.card(PkPalette.kitoNavy900).single;
        final hero = PkShadows.hero(PkPalette.kitoBlue700).single;
        expect(card.blurRadius, lessThanOrEqualTo(12));
        expect(card.offset.dy, inInclusiveRange(3, 4));
        expect(hero.blurRadius, inInclusiveRange(16, 20));
        expect(hero.offset.dy, inInclusiveRange(6, 8));
      },
    );
  });

  group('contrast (5.6, 9.5)', () {
    // WCAG 2.2 relative luminance.
    double luminance(Color color) {
      double channel(double value) => value <= 0.03928
          ? value / 12.92
          : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
      return 0.2126 * channel(color.r) +
          0.7152 * channel(color.g) +
          0.0722 * channel(color.b);
    }

    double ratio(Color foreground, Color background) {
      final a = luminance(foreground);
      final b = luminance(background);
      return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
    }

    for (final entry in {
      'light': PkSemanticColors.light,
      'dark': PkSemanticColors.dark,
    }.entries) {
      final semantic = entry.value;
      final name = entry.key;

      test('body text clears 4.5:1 on every surface in $name', () {
        // Section 5.6 singles out `textTertiary`, which is where palette
        // intent has historically been mistaken for measured contrast.
        for (final background in {
          'page': semantic.page,
          'surface': semantic.surface,
          'sunken': semantic.sunken,
        }.entries) {
          for (final foreground in {
            'textPrimary': semantic.textPrimary,
            'textSecondary': semantic.textSecondary,
          }.entries) {
            expect(
              ratio(foreground.value, background.value),
              greaterThanOrEqualTo(4.5),
              reason:
                  '${foreground.key} on ${background.key} in $name is too low',
            );
          }
        }
      });

      test('status colours clear 3:1 as non-text meaning in $name', () {
        for (final background in {
          'page': semantic.page,
          'surface': semantic.surface,
        }.entries) {
          for (final foreground in {
            'success': semantic.success,
            'danger': semantic.danger,
            'warning': semantic.warning,
            'owed': semantic.owed,
            'owing': semantic.owing,
            'sharedStrong': semantic.sharedStrong,
          }.entries) {
            expect(
              ratio(foreground.value, background.value),
              greaterThanOrEqualTo(3),
              reason:
                  '${foreground.key} on ${background.key} in $name is too low',
            );
          }
        }
      });

      test('tertiary text clears the large-text floor in $name', () {
        for (final background in {
          'page': semantic.page,
          'surface': semantic.surface,
          'sunken': semantic.sunken,
        }.entries) {
          expect(
            ratio(semantic.textTertiary, background.value),
            greaterThanOrEqualTo(3),
            reason: 'textTertiary on ${background.key} in $name is too low',
          );
        }
      });
    }
  });
}
