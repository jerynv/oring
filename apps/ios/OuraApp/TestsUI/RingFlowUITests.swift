import XCTest

final class RingFlowUITests: XCTestCase {
    func testPairingKeySettingsReturnsToRingSettings() {
        let app = XCUIApplication()
        app.launchArguments = ["-previewRing"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Your ring"].waitForExistence(timeout: 15))
        app.buttons["Ring settings"].tap()
        XCTAssertTrue(app.staticTexts["Your ring, your way."].waitForExistence(timeout: 5))
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Pairing key")).firstMatch.tap()
        XCTAssertTrue(app.secureTextFields["Pairing key"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Save pairing key"].exists)
        app.navigationBars["Pairing key"].buttons.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Your ring, your way."].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Enter your pairing key."].exists)
    }

    func testDataDeletionAndRingResetAreReachable() {
        let app = XCUIApplication()
        app.launchArguments = ["-openSync"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Bring your ring close."].waitForExistence(timeout: 15))
        app.buttons["Advanced & diagnostics"].tap()
        let delete = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Delete all local data")).firstMatch
        XCTAssertTrue(delete.waitForExistence(timeout: 5))
        XCTAssertTrue(delete.isEnabled)
        delete.tap()
        XCTAssertTrue(app.alerts["Delete all local data?"].waitForExistence(timeout: 5))
        app.alerts.buttons["Cancel"].tap()
        let ringReset = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Factory-reset the ring")).firstMatch
        XCTAssertTrue(ringReset.isEnabled)
        ringReset.tap()
        XCTAssertTrue(app.alerts["Reset unavailable"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "identify it before erasing it")).firstMatch.exists)
    }

    func testProfileShowsLabeledBlankFieldsAndRejectsInvalidAge() {
        let app = XCUIApplication()
        app.launch()
        let profile = app.buttons["Profile"]
        XCTAssertTrue(profile.waitForExistence(timeout: 15))
        profile.tap()
        XCTAssertTrue(app.staticTexts["About you"].waitForExistence(timeout: 5))
        for field in ["Age", "Height", "Weight", "Ring size"] {
            XCTAssertTrue(app.textFields[field].exists, "Missing labeled field: \(field)")
        }
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "profile"
        shot.lifetime = .keepAlways
        add(shot)
        let age = app.textFields["Age"]
        age.tap()
        age.typeText("0")
        XCTAssertTrue(app.staticTexts["Enter a positive number for age."].exists)
        XCTAssertFalse(app.buttons["Save"].isEnabled)
    }

    func testStaleBondExplainsForgetThisDevice() {
        let app = XCUIApplication()
        app.launchArguments = ["-simulateStaleBond"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Old Bluetooth pairing"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Forget This Device")).firstMatch.exists)
        XCTAssertTrue(app.buttons["Create a pairing key"].exists)
    }

    func testSampleNightAndPairingEntry() {
        let app = XCUIApplication()
        app.launch()
        let sample = app.buttons["Explore a sample night"]
        XCTAssertTrue(sample.waitForExistence(timeout: 15))
        sample.tap()
        XCTAssertTrue(app.staticTexts["Sample data · illustration only"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", "sleep stages")).firstMatch.exists)
        let shot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        shot.name = "sample-night"
        shot.lifetime = .keepAlways
        add(shot)
        app.swipeUp()
        let axisShot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        axisShot.name = "sample-night-axis"
        axisShot.lifetime = .keepAlways
        add(axisShot)
        app.buttons["Back"].tap()
        let pair = app.buttons["Get started"]
        XCTAssertTrue(pair.waitForExistence(timeout: 5))
        pair.tap()
        XCTAssertTrue(app.staticTexts["Bring your ring close."].waitForExistence(timeout: 5))
        app.buttons["My ring is ready"].tap()
        XCTAssertTrue(app.staticTexts["How was it paired?"].waitForExistence(timeout: 5))
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "I have a pairing key")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Enter your pairing key."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.secureTextFields["Pairing key"].exists)
        let pairingShot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        pairingShot.name = "pairing"
        pairingShot.lifetime = .keepAlways
        add(pairingShot)
    }
}
