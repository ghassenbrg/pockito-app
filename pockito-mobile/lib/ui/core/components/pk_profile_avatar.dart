import 'package:flutter/material.dart';

import '../../../domain/pockito_models.dart';

/// A user's avatar, falling back to their initials.
///
/// The fallback is initials rather than a stock silhouette: a user who has not
/// uploaded a photo should still see something that is recognisably theirs.
/// A photo that fails to load falls back the same way instead of showing a
/// broken image.
class PkProfileAvatar extends StatelessWidget {
  const PkProfileAvatar({super.key, required this.profile, this.size = 48});

  final Profile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = Text(
      profile.initials,
      style: TextStyle(
        fontSize: size * 0.36,
        fontWeight: FontWeight.w700,
        color: colors.onSecondaryContainer,
      ),
    );

    return Semantics(
      label: profile.displayName,
      image: true,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.secondaryContainer,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: profile.avatarUrl == null
            ? initials
            : Image.network(
                profile.avatarUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => initials,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : initials,
              ),
      ),
    );
  }
}
