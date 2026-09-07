import SwiftUI

struct RingSyncVisual: View {
    let battery: Int?

    private var fraction: CGFloat {
        CGFloat(max(0, min(100, battery ?? 0))) / 100
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image("RingHero")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 205, height: 205)
                    .accessibilityHidden(true)
                if battery != nil {
                    Circle()
                        .trim(from: 0.1, to: 0.9)
                        .stroke(Obs.rule, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 248, height: 248)
                        .rotationEffect(.degrees(90))
                    Circle()
                        .trim(from: 0.1, to: 0.1 + fraction * 0.8)
                        .stroke(Obs.good, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 248, height: 248)
                        .rotationEffect(.degrees(90))
                }
            }
            .frame(width: 260, height: 260)
            Text(battery.map { "\($0)% ring battery" } ?? "Battery appears after the first sync")
                .font(.footnote.weight(.medium))
                .foregroundStyle(battery == nil ? Obs.muted : Obs.good)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(battery.map { "Ring battery \($0) percent" } ?? "Ring battery unavailable until first sync")
    }
}
