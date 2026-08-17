import SwiftUI
import WidgetKit

// The home-screen widget.
//
// It renders whatever the app last wrote to the shared App Group and never
// computes a figure of its own — a widget that did its own arithmetic would be
// a second place for the numbers to be wrong.
//
// To activate: File ▸ New ▸ Target ▸ Widget Extension named "PockitoWidget",
// add this file to it, and enable the App Group `group.app.pockito` on both
// the app target and the extension.

private let appGroup = "group.app.pockito"

struct PockitoEntry: TimelineEntry {
    let date: Date
    let netWorthLabel: String
    let netWorth: String
    let spentLabel: String
    let spent: String
    let comparison: String
    let waiting: String
    let debt: String

    static func current() -> PockitoEntry {
        let defaults = UserDefaults(suiteName: appGroup)
        func value(_ key: String, _ fallback: String = "") -> String {
            defaults?.string(forKey: key) ?? fallback
        }
        return PockitoEntry(
            date: Date(),
            netWorthLabel: value("netWorthLabel", "Net worth"),
            netWorth: value("netWorth", "—"),
            spentLabel: value("spentLabel", "Spent"),
            spent: value("spent", "—"),
            comparison: value("comparison"),
            waiting: value("waiting"),
            debt: value("debt")
        )
    }
}

struct PockitoProvider: TimelineProvider {
    func placeholder(in context: Context) -> PockitoEntry { .current() }

    func getSnapshot(
        in context: Context,
        completion: @escaping (PockitoEntry) -> Void
    ) {
        completion(.current())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<PockitoEntry>) -> Void
    ) {
        // The app pushes on every change, so the schedule is only a safety net.
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        completion(Timeline(entries: [.current()], policy: .after(next)))
    }
}

struct PockitoWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PockitoEntry

    private var brand: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.09, green: 0.25, blue: 0.68),
                Color(red: 0.14, green: 0.36, blue: 0.85),
                Color(red: 0.07, green: 0.56, blue: 0.69),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(family == .systemSmall ? "" : entry.netWorthLabel)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                Spacer()
                // Only drawn when something is actually waiting, so the badge
                // never becomes background noise.
                if !entry.waiting.isEmpty {
                    Text(entry.waiting)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.white.opacity(0.22)))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                }
            }
            Text(entry.netWorth)
                .font(family == .systemSmall ? .title3 : .title)
                .bold()
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            if family != .systemSmall {
                Divider().overlay(.white.opacity(0.18))
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.spentLabel)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                        Text(entry.spent)
                            .font(.headline)
                            .monospacedDigit()
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text(entry.comparison)
                        .font(.caption2)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(2)
                }
            }

            if family == .systemLarge, !entry.debt.isEmpty {
                Divider().overlay(.white.opacity(0.18))
                Label(entry.debt, systemImage: "hands.sparkles")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .containerBackground(for: .widget) { brand }
    }
}

@main
struct PockitoWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PockitoWidget", provider: PockitoProvider()) {
            PockitoWidgetView(entry: $0)
        }
        .configurationDisplayName("Pockito")
        .description("Net worth and this month, at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
