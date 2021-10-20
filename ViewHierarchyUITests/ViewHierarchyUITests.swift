import XCTest

class ViewHierarchyUITests: XCTestCase {
    var app: XCUIApplication!
    let device = XCUIDevice.shared

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication(bundleIdentifier: "com.apple.Health")
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
    }

    func testExample() throws {
        let viewHierarchy = Utils.getViewHierarchy(app: app)
        print(viewHierarchy)
        
        // Set breakpoint below
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"mainTabBarController\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Browse"].tap()
    }
}
