
import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    func testYesButton() {
        
        //Given
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        //When
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        //Then
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual (indexLabel.label, "2/10")
    }
    func testNoButton() {
        //Given
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        //When
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        //Then
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testQuizResultAlert() {
        //Given
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep (2)
        }
        //When
        let alert = app.alerts["Этот раунд окончен!"]
        //Then
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertGoesAway() {
        //Given
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        //When
        app.buttons["Сыграть ещё раз"].tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        //Then
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }
    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
