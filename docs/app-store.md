# App Store release handoff

## Listing draft

**Name:** Oring — Ring Sleep Journal

**Subtitle:** Explore your nights directly

**Description:** Oring connects to compatible Oura rings over Bluetooth and keeps your ring history on your iPhone. Explore the ring's own deep, light, REM, and awake sleep-stage pattern in an interactive hypnogram. Scrub aligned heart rate, HRV, oxygen, skin temperature, and motion charts when your ring has those records. Review daily activity and trends. No Oring account, subscription, ads, or cloud server. An explicitly labeled sample night lets you explore before pairing. Oring is an independent app, not affiliated with Oura Health. Compatibility depends on ring model and firmware; see support details before resetting a ring.

**Keywords:** sleep, ring, REM, hypnogram, HRV, Bluetooth, journal

**Category suggestion:** Health & Fitness

## Owner release steps

1. Assign the final bundle identifier and Apple Developer team. Build the Rust device and simulator library with `apps/ios/build-xcframework.sh`, generate the Xcode project from `apps/ios/OuraApp/project.yml`, and archive a signed Release build.
2. Test a physical compatible ring end to end: key entry or fresh pairing, Bluetooth permission, event sync, the ring's stage epochs, REM graph, and trends. Check reconnects and firmware behavior. Do not factory-reset the owner's ring without backing up any unsynced data and obtaining their direct approval.
3. Host [the privacy policy](privacy-policy.md) at a public HTTPS URL. Supply real support contact and help pages that explain the existing-key and factory-reset paths. Review the app's final privacy answers and linked libraries.
4. Capture final App Store screenshots from the signed app in App Store Connect's required sizes. Keep the “Sample data” label visible on demo screenshots; never portray it as a user's measurement.
5. In App Review notes, say the app uses Bluetooth Low Energy to communicate with a physical Oura ring and identify at least one specific supported ring model tested. Explain that the reviewer can tap **Explore a sample night** without hardware. Provide any test instructions Apple asks for.
6. Answer App Store Connect's encryption export questionnaire based on the Rust library's AES use and planned distribution regions. The project deliberately leaves `ITSAppUsesNonExemptEncryption` unset pending that determination. Submit any required documents.
7. Set pricing to Free, complete age rating and availability, then upload and submit through Xcode Organizer/App Store Connect. Check the final app name and compatibility wording against Apple's current review rules before submission.

## Current evidence and limit

The simulator build, labeled sample report, pairing entry screen, 9 automated tests, and an unsigned Release archive have run. This workspace has no physical Oura ring, pairing key, Apple Developer signing identity, or App Store Connect access. Real Bluetooth behavior and App Store approval remain unproven.
