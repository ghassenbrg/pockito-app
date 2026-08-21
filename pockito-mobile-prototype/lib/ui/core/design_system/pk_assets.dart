enum KitoAsset {
  appIcon('assets/mascot/kito/runtime/kito-app-icon.png'),
  avatar('assets/mascot/kito/runtime/kito-avatar.png'),
  defaultPose('assets/mascot/kito/runtime/kito-default.png'),
  welcome('assets/mascot/kito/runtime/kito-welcome.png'),
  thinking('assets/mascot/kito/runtime/kito-thinking.png'),
  celebrating('assets/mascot/kito/runtime/kito-celebrating.png'),
  concerned('assets/mascot/kito/runtime/kito-concerned.png'),
  sleeping('assets/mascot/kito/runtime/kito-sleeping.png'),
  confused('assets/mascot/kito/runtime/kito-confused.png'),
  receipt('assets/mascot/kito/runtime/kito-receipt.png'),
  sharedSpace('assets/mascot/kito/runtime/kito-shared-space.png'),
  empty('assets/mascot/kito/runtime/kito-empty.png'),
  pointing('assets/mascot/kito/runtime/kito-pointing.png'),
  surprised('assets/mascot/kito/runtime/kito-surprised.png');

  const KitoAsset(this.path);

  final String path;
}

abstract final class PkAssetPaths {
  static const mascotRuntime = 'assets/mascot/kito/runtime/';
  static const mascotSource = 'assets/mascot/kito/source/';
}
