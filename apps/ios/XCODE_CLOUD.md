# Xcode Cloud

The shipping iPhone project is generated from `apps/ios/OuraApp/project.yml`. The repository does not commit the generated `OuraApp.xcodeproj` or `OuraCore.xcframework`; `ci_scripts/ci_post_clone.sh` installs the needed tools, builds the Rust device/simulator framework, and generates the project after clone.

Configure the workflow to run that post-clone script, then archive the `OuraApp` scheme. Set the Apple Developer team and signing profile in the workflow. The app uses CoreBluetooth and stores ring events locally. Its labeled sample night is available to App Review without hardware; physical BLE behavior must also be tested on a ring before submission.
