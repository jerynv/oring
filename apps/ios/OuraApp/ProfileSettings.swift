import SwiftUI

private struct EditableProfile {
    var sex: String
    var age: String
    var heightCm: String
    var weightKg: String
    var ringSize: String

    init(_ profile: Profile?) {
        sex = profile?.sex ?? ""
        age = profile?.age.map { Self.format($0) } ?? ""
        heightCm = profile?.height_m.map { Self.format($0 * 100) } ?? ""
        weightKg = profile?.weight_kg.map(Self.format) ?? ""
        ringSize = profile?.ring_size.map(Self.format) ?? ""
    }

    private static func format(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
    }

    private func number(_ raw: String) -> Double? {
        Double(raw.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    var validation: String? {
        for (label, raw) in [("Age", age), ("Height", heightCm), ("Weight", weightKg), ("Ring size", ringSize)] {
            guard !raw.isEmpty else { continue }
            guard let value = number(raw), value.isFinite, value > 0 else {
                return "Enter a positive number for \(label.lowercased())."
            }
        }
        return nil
    }

    var values: [String: Any] {
        var out: [String: Any] = [:]
        if !sex.isEmpty { out["sex"] = sex }
        if let value = number(age) { out["age"] = value }
        if let value = number(heightCm) { out["height_m"] = value / 100 }
        if let value = number(weightKg) { out["weight_kg"] = value }
        if let value = number(ringSize) { out["ring_size"] = value }
        return out
    }
}

private enum ProfileStore {
    static var url: URL { DB.url.deletingLastPathComponent().appendingPathComponent("profile.json") }

    static func save(_ profile: EditableProfile) throws {
        let data = try JSONSerialization.data(withJSONObject: profile.values,
                                              options: [.prettyPrinted, .sortedKeys])
        try data.write(to: url, options: .atomic)
    }
}

private struct ProfileNumberField: View {
    let title: String
    let unit: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.subheadline.weight(.medium)).foregroundStyle(Obs.ink2)
            HStack(spacing: 10) {
                TextField("Not set", text: $value)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundStyle(Obs.ink)
                    .accessibilityLabel(title)
                Text(unit).font(.subheadline).foregroundStyle(Obs.muted)
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 56)
            .background(Obs.rule.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct ProfileSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var profile: EditableProfile
    @State private var message: String?
    let onSaved: () -> Void

    init(profile: Profile?, onSaved: @escaping () -> Void) {
        _profile = State(initialValue: EditableProfile(profile))
        self.onSaved = onSaved
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SpaceBackdrop()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 27, weight: .light))
                                .foregroundStyle(Obs.link)
                                .frame(width: 54, height: 54)
                                .background(Obs.rule.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("About you")
                                    .font(.system(.title2, weight: .semibold))
                                    .foregroundStyle(Obs.ink)
                                Text("Optional details for activity and heart estimates.")
                                    .font(.subheadline).foregroundStyle(Obs.ink2)
                            }
                        }
                        .padding(.top, 12)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("PERSONAL DETAILS")
                                .font(.caption.weight(.semibold)).tracking(1.3).foregroundStyle(Obs.muted)
                            VStack(alignment: .leading, spacing: 9) {
                                Text("Biological sex")
                                    .font(.subheadline.weight(.medium)).foregroundStyle(Obs.ink2)
                                Picker("Biological sex", selection: $profile.sex) {
                                    Text("Not set").tag("")
                                    Text("Female").tag("F")
                                    Text("Male").tag("M")
                                    Text("Other").tag("O")
                                }
                                .pickerStyle(.menu)
                                .tint(Obs.ink)
                                .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                                .padding(.horizontal, 16)
                                .background(Obs.rule.opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
                            }
                            ProfileNumberField(title: "Age", unit: "years", value: $profile.age)
                            ProfileNumberField(title: "Height", unit: "cm", value: $profile.heightCm)
                            ProfileNumberField(title: "Weight", unit: "kg", value: $profile.weightKg)
                        }
                        VStack(alignment: .leading, spacing: 15) {
                            Text("YOUR RING")
                                .font(.caption.weight(.semibold)).tracking(1.3).foregroundStyle(Obs.muted)
                            ProfileNumberField(title: "Ring size", unit: "size", value: $profile.ringSize)
                        }
                        Text("Saved only on this iPhone. Blank fields stay blank; Oring never substitutes guessed measurements.")
                            .font(.footnote).foregroundStyle(Obs.muted)
                            .fixedSize(horizontal: false, vertical: true)
                        if let validation = profile.validation {
                            Label(validation, systemImage: "exclamationmark.circle")
                                .font(.footnote).foregroundStyle(Obs.bad)
                        }
                        if let message {
                            Label(message, systemImage: "exclamationmark.circle")
                                .font(.footnote).foregroundStyle(Obs.bad)
                        }
                    }
                    .frame(maxWidth: 520)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard profile.validation == nil else { return }
                        do {
                            try ProfileStore.save(profile)
                            onSaved()
                            dismiss()
                        } catch { message = "Could not save: \(error.localizedDescription)" }
                    }
                    .disabled(profile.validation != nil)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
                }
            }
        }
        .tint(Obs.link)
    }
}
