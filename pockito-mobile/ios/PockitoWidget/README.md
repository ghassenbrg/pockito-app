# Pockito home-screen widget (iOS)

`PockitoWidget.swift` is the finished widget. WidgetKit extensions cannot be
added from the command line — Xcode has to create the target — so activating it
is three steps:

1. **File ▸ New ▸ Target ▸ Widget Extension**, named `PockitoWidget`.
   Uncheck "Include Configuration Intent".
2. Replace the generated Swift file with `PockitoWidget.swift` from this folder.
3. **Signing & Capabilities ▸ + App Group ▸ `group.app.pockito`** on *both* the
   `Runner` target and the `PockitoWidget` target.

Then add the matching platform channel to `ios/Runner/AppDelegate.swift`, so the
app can push its figures the way `MainActivity.kt` already does on Android:

```swift
let channel = FlutterMethodChannel(
  name: "app.pockito/widget",
  binaryMessenger: controller.binaryMessenger
)
channel.setMethodCallHandler { call, result in
  guard call.method == "update",
        let payload = call.arguments as? [String: String] else {
    result(FlutterMethodNotImplemented); return
  }
  let defaults = UserDefaults(suiteName: "group.app.pockito")
  payload.forEach { defaults?.set($1, forKey: $0) }
  WidgetCenter.shared.reloadAllTimelines()
  result(nil)
}
```

The Dart side needs no change: `PkHomeWidgetBridge` already speaks
`app.pockito/widget` and swallows `MissingPluginException`, so the app behaves
correctly before and after the target exists.
