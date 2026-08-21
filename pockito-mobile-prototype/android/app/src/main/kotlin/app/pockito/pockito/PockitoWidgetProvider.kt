package app.pockito.pockito

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

/**
 * The home-screen widget.
 *
 * It renders whatever the app last handed over and never computes a figure of
 * its own — a widget that did its own arithmetic would be a second place for
 * the numbers to be wrong.
 */
class PockitoWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray,
    ) {
        ids.forEach { id -> render(context, manager, id) }
    }

    companion object {
        const val PREFS = "app.pockito.widget"

        /** Redraws every placed widget. Called after the app pushes new data. */
        fun renderAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, PockitoWidgetProvider::class.java),
            )
            ids.forEach { id -> render(context, manager, id) }
        }

        private fun render(
            context: Context,
            manager: AppWidgetManager,
            id: Int,
        ) {
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.pockito_widget)

            views.setTextViewText(
                R.id.widget_net_worth_label,
                prefs.getString("netWorthLabel", "Net worth"),
            )
            views.setTextViewText(
                R.id.widget_net_worth,
                prefs.getString("netWorth", "—"),
            )
            views.setTextViewText(
                R.id.widget_spent_label,
                prefs.getString("spentLabel", "Spent"),
            )
            views.setTextViewText(R.id.widget_spent, prefs.getString("spent", "—"))
            views.setTextViewText(
                R.id.widget_comparison,
                prefs.getString("comparison", ""),
            )

            // The badge and the debt line are only drawn when they carry
            // something; an empty row on a widget is wasted glanceable space.
            val waiting = prefs.getString("waiting", "").orEmpty()
            views.setTextViewText(R.id.widget_waiting, waiting)
            views.setViewVisibility(
                R.id.widget_waiting,
                if (waiting.isEmpty()) View.GONE else View.VISIBLE,
            )

            val debt = prefs.getString("debt", "").orEmpty()
            views.setTextViewText(R.id.widget_debt, debt)
            views.setViewVisibility(
                R.id.widget_debt,
                if (debt.isEmpty()) View.GONE else View.VISIBLE,
            )

            // Tapping anywhere opens the app: a widget with several targets
            // makes the user aim at a 40dp row on a home screen.
            val launch = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
                ?.apply { flags = Intent.FLAG_ACTIVITY_SINGLE_TOP }
            if (launch != null) {
                views.setOnClickPendingIntent(
                    R.id.widget_root,
                    PendingIntent.getActivity(
                        context,
                        0,
                        launch,
                        PendingIntent.FLAG_UPDATE_CURRENT or
                            PendingIntent.FLAG_IMMUTABLE,
                    ),
                )
            }
            manager.updateAppWidget(id, views)
        }
    }
}
