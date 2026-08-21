package app.pockito.pockito

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    /**
     * The one-way bridge that keeps the home-screen widget in step with the
     * app. Dart hands over already-formatted strings; nothing here formats
     * money, so there is only ever one place that can get it wrong.
     */
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method != "update") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val payload = call.arguments as? Map<*, *>
                if (payload == null) {
                    result.error("bad_args", "Expected a map of strings", null)
                    return@setMethodCallHandler
                }
                getSharedPreferences(
                    PockitoWidgetProvider.PREFS,
                    Context.MODE_PRIVATE,
                ).edit().apply {
                    payload.forEach { (key, value) ->
                        putString(key.toString(), value?.toString().orEmpty())
                    }
                    apply()
                }
                PockitoWidgetProvider.renderAll(applicationContext)
                result.success(null)
            }
    }

    private companion object {
        const val CHANNEL = "app.pockito/widget"
    }
}
