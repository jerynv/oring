import SwiftUI
import UIKit

// thomas.md Quiet Ink: warm paper, serif titles, sans UI, mono numbers.
// Color is semantic, not decorative: gray when nothing is going on, green when
// something is genuinely good, orange/red when there is a problem.

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

    // Night-sky almanac: warm paper by day and deep ink by night.
    static let paper = adaptive(light: 0xf7f5ef, dark: 0x101b25)
    static let ink = adaptive(light: 0x172b38, dark: 0xf4f1e9)
    static let ink2 = adaptive(light: 0x465969, dark: 0xc4d0d7)
    static let muted = adaptive(light: 0x5e6b74, dark: 0xacc0cb)
    static let link = adaptive(light: 0x99520f, dark: 0xf2ac63)
    static let rule = adaptive(light: 0xd8ddd8, dark: 0x344450)
    static let chart = adaptive(light: 0x204d6c, dark: 0x5b9fc2)
    static let good = adaptive(light: 0x327868, dark: 0x8ad0b8)
    static let bad = adaptive(light: 0x99520f, dark: 0xe4aa69)
    static let alert = adaptive(light: 0xa6432b, dark: 0xed8d77)

    static var teal: Color { chart }
    static var yellow: Color { bad }
    static var warn: Color { bad }
    static var black: Color { paper }
    static var base: Color { paper }
    static var baseLow: Color { paper }
    static var trace: Color { rule }
    static var canvas: some View { paper.ignoresSafeArea() }

    static let deep = adaptive(light: 0x204d6c, dark: 0x5b9fc2)
    static let light = adaptive(light: 0x78a9b7, dark: 0xa6cbd4)
    static let rem = adaptive(light: 0x327868, dark: 0x8ad0b8)
    static let wake = adaptive(light: 0xb37530, dark: 0xe4aa69)
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
        .system(size: size, weight: weight, design: .serif)
    }
    static func mono(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
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
            Text(value).font(Obs.mono(15, .medium)).foregroundStyle(accent)
                .monospacedDigit()
        }
    }
}
