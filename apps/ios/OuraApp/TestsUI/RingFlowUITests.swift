import XCTest

final class RingFlowUITests: XCTestCase {
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
        let pair = app.buttons["Pair or sync your ring"]
        XCTAssertTrue(pair.waitForExistence(timeout: 5))
        pair.tap()
        XCTAssertTrue(app.staticTexts["Pair your ring"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.secureTextFields["Pairing key"].exists)
        let pairingShot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        pairingShot.name = "pairing"
        pairingShot.lifetime = .keepAlways
        add(pairingShot)
    }
}
