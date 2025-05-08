//___FILEHEADER___

import XCTest

final class OnTime___Transit_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        app.launchArguments.append("isUiTest")
        
        app.launch()

        app/*@START_MENU_TOKEN@*/.searchFields["Station Search"]/*[[".navigationBars.searchFields[\"Station Search\"]",".searchFields",".containing(.image, identifier: \"magnifyingglass\").firstMatch",".firstMatch",".searchFields[\"Station Search\"]"],[[[-1,4],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements/*@START_MENU_TOKEN@*/.containing(.button, identifier: "Next keyboard").firstMatch/*[[".element(boundBy: 14)",".containing(.button, identifier: \"dictation\").firstMatch",".containing(.button, identifier: \"Next keyboard\").firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["J"]/*[[".otherElements.keys[\"J\"]",".keys[\"J\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".otherElements.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".otherElements.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["S+U Jannowitzbrücke"]/*[[".buttons.staticTexts[\"S+U Jannowitzbrücke\"]",".staticTexts[\"S+U Jannowitzbrücke\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons.containing(.staticText, identifier: "Hermannstraße").firstMatch/*[[".buttons.containing(.staticText, identifier: \"Hermannstraße\").firstMatch",".otherElements.buttons[\"U8, Hermannstraße, 11:10\"]",".buttons[\"U8, Hermannstraße, 11:10\"]"],[[[-1,2],[-1,1],[-1,0]]],[2]]@END_MENU_TOKEN@*/.tap()
                
                
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
