import SwiftUI
import UIKit

// A quiet night sky, with Apple's system type and stage colors used consistently.

enum Obs {
    private static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { trait in
            let hex = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xff) / 255,
                green: CGFloat((hex >> 8) & 0xff) / 255,
                blue: CGFloat(hex & 0xff) / 255,
                alpha: 1)
        })
    }

    static let paper = adaptive(light: 0x080e1e, dark: 0x080e1e)
    static let ink = adaptive(light: 0xf6f8ff, dark: 0xf6f8ff)
    static let ink2 = adaptive(light: 0xc7d1e5, dark: 0xc7d1e5)
    static let muted = adaptive(light: 0x9caec9, dark: 0x9caec9)
    static let link = adaptive(light: 0xb8c9ff, dark: 0xb8c9ff)
    static let rule = adaptive(light: 0x26344d, dark: 0x26344d)
    static let chart = adaptive(light: 0x91b4ff, dark: 0x91b4ff)
    static let good = adaptive(light: 0xa1ddca, dark: 0xa1ddca)
    static let bad = adaptive(light: 0xe5c18d, dark: 0xe5c18d)
    static let alert = adaptive(light: 0xf1a9a5, dark: 0xf1a9a5)

    static var teal: Color { chart }
    static var yellow: Color { bad }
    static var warn: Color { bad }
    static var black: Color { paper }
    static var base: Color { paper }
    static var baseLow: Color { paper }
    static var trace: Color { rule }
    static var canvas: some View { paper.ignoresSafeArea() }

    static let deep = adaptive(light: 0x6e8ff4, dark: 0x6e8ff4)
    static let light = adaptive(light: 0xa9c3eb, dark: 0xa9c3eb)
    static let rem = adaptive(light: 0x9fddcf, dark: 0x9fddcf)
    static let wake = adaptive(light: 0xe4c5a2, dark: 0xe4c5a2)
    static func stage(_ s: Int) -> Color {
        switch s { case 1: return deep; case 2: return light; case 3: return rem; default: return wake }
    }

    /// Color a delta only when it is large enough to be worth noticing.
    static func tone(delta: Double?, goodWhenPositive: Bool = true, threshold: Double = 8) -> Color {
        guard let d = delta else { return chart }
        let isGood = d >= 0 ? goodWhenPositive : !goodWhenPositive
        if abs(d) < threshold { return chart }
        return isGood ? good : bad
    }

    static func debt(_ state: String) -> Color {
        switch state {
        case "none": return good
        case "low": return chart
        case "moderate": return bad
        case "high": return alert
        default: return chart
        }
    }

    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    static func mono(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: max(size, 11), weight: weight, design: .default)
    }
    static func prose(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight)
    }
}

struct ObsTag: View {
    let text: String
    var icon: String? = nil
    init(_ text: String, icon: String? = nil) { self.text = text; self.icon = icon }
    var body: some View {
        HStack(spacing: 7) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Obs.muted)
            }
            Text(text.uppercased())
                .font(Obs.mono(11, .medium))
                .tracking(1.6)
                .foregroundStyle(Obs.muted)
        }
    }
}

/// Hairline between home sections — the thomas.md rule, with air on both sides.
struct ObsRule: View {
    var body: some View {
        Rectangle().fill(Obs.rule).frame(height: 1)
            .padding(.top, 6).padding(.bottom, 2)
    }
}

struct ObsCard: ViewModifier {
    var padding: CGFloat = 18
    var radius: CGFloat = 10
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Obs.paper, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Obs.rule, lineWidth: 1)
            )
    }
}

extension View {
    func obsCard(padding: CGFloat = 18, radius: CGFloat = 10) -> some View {
        modifier(ObsCard(padding: padding, radius: radius))
    }
}

struct ObsStat: View {
    let label: String
    let value: String
    var accent: Color = Obs.ink
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label).font(Obs.mono(13)).foregroundStyle(Obs.ink2)
            Spacer(minLength: 16)
            Text(value == "–" ? "Not yet" : value)
                .font(Obs.mono(15, .medium))
                .foregroundStyle(value == "–" ? Obs.muted : accent)
                .monospacedDigit()
        }
    }
}

struct SpaceEmptyState: View {
    let symbol: String
    let title: String
    let message: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var glowing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .leading) {
                Ellipse()
                    .fill(Obs.link.opacity(glowing ? 0.19 : 0.10))
                    .frame(width: 150, height: 66)
                    .blur(radius: 30)
                    .offset(x: -14, y: 18)
                Image(systemName: symbol)
                    .font(.system(size: 58, weight: .ultraLight))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Obs.link)
                    .shadow(color: Obs.link.opacity(0.35), radius: glowing ? 18 : 7)
            }
                .frame(width: 150, height: 110, alignment: .leading)
                .accessibilityHidden(true)
            Text(title)
                .font(.system(.title2, design: .default, weight: .semibold))
                .foregroundStyle(Obs.ink)
                .padding(.top, 15)
            Text(message)
                .font(.body)
                .foregroundStyle(Obs.ink2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                glowing = true
            }
        }
    }
}
