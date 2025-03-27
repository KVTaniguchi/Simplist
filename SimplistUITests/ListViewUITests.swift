import XCTest

final class SimplistUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        // Delete all items before each test
        deleteAllItems()
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        deleteAllItems()
    }
    
    private func deleteAllItems() {
        // Find and tap the "Delete all completed" button if it exists
        let deleteAllButton = app.buttons["Delete all completed"].firstMatch
        if deleteAllButton.exists {
            deleteAllButton.tap()
        }
        
        // Delete any remaining items by swiping
        let cells = app.collectionViews.cells
        while cells.count > 0 {
            let cell = cells.element(boundBy: 0)
            cell.swipeLeft(velocity: .slow)
            
            let deleteButton = app.buttons["Delete"].firstMatch
            if deleteButton.exists {
                deleteButton.tap()
            }
        }
    }
    
    func testAddNewItem() throws {
        // Tap add button
        app.buttons["Add Item"].tap()
        
        sleep(1)
        
        // Type in the new item
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test Item")
        
        // Tap add button in sheet
        app.buttons["Save"].tap()
        
        // Verify item exists
        XCTAssertTrue(app.staticTexts["Test Item"].exists)
    }
    
    func testDeleteItem() throws {
        // First add an item
        try testAddNewItem()
        
        // Find the list cell containing our item and swipe to delete
        let listItem = app.collectionViews.cells.containing(.staticText, identifier: "Test Item").element
        listItem.swipeLeft(velocity: .slow)
        
        sleep(1)
        
        // Wait for and tap the delete button
        let deleteButton = app.buttons["Delete"].firstMatch
        deleteButton.tap()
        
        sleep(1)
        
        // Verify item is deleted
        XCTAssertFalse(app.collectionViews.cells.containing(.staticText, identifier: "Test Item").element.exists)
    }
    
    func testCompleteItem() throws {
        // First add an item
        try testAddNewItem()
        
        // Find and tap the checkbox image
        let checkbox = app.images["circle"].firstMatch
        XCTAssertTrue(checkbox.waitForExistence(timeout: 5))
        checkbox.tap()
        
        // Wait for and verify item moved to completed section
        let completedSection = app.collectionViews.cells.containing(NSPredicate(format: "label CONTAINS %@", "Test Item"))
        XCTAssertTrue(completedSection.element.waitForExistence(timeout: 5))
    }
    
    func testDeleteAllCompleted() throws {
        // Add and complete two items
        try testAddNewItem()
        
        sleep(1)
        
        // Add second item
        app.buttons["Add Item"].tap()
        
        sleep(1)
        
        // Wait for and interact with text field
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test Item 2")
        
        sleep(1)
        
        // Tap save button
        app.buttons["Save"].tap()
        
        sleep(1)
        
        // Wait for both items to be visible
        let firstItem = app.staticTexts["Test Item"]
        let secondItem = app.staticTexts["Test Item 2"]
        XCTAssertTrue(firstItem.waitForExistence(timeout: 5))
        XCTAssertTrue(secondItem.waitForExistence(timeout: 5))
        
        sleep(1)
        
        // Complete both items
        let checkboxes = app.images.matching(identifier: "circle")
        XCTAssertTrue(checkboxes.count >= 2, "Expected at least 2 checkboxes to be present")
        
        sleep(1)
        
        // Tap first checkbox
        checkboxes.element(boundBy: 0).tap()
        
        // Wait for first item to move to completed section
        sleep(1)
        
        // Tap second checkbox
        checkboxes.element(boundBy: 0).tap()
        
        // Wait for and tap delete all completed button
        let deleteAllButton = app.buttons["Delete all completed"]
        XCTAssertTrue(deleteAllButton.waitForExistence(timeout: 5))
        deleteAllButton.tap()
        
        // Verify no items exist
        XCTAssertFalse(app.staticTexts["Test Item"].exists)
        XCTAssertFalse(app.staticTexts["Test Item 2"].exists)
    }
    
    func testReorderItems() throws {
        // Add two items
        try testAddNewItem()
        
        sleep(1)
        
        // Add second item
        app.buttons["Add Item"].tap()
        
        sleep(1)
        
        // Wait for and interact with text field
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("Test Item 2")
        
        sleep(1)
        
        // Tap save button
        app.buttons["Save"].tap()
        
        sleep(1)
        
        // Wait for both items to exist
        let firstItem = app.staticTexts["Test Item"]
        let secondItem = app.staticTexts["Test Item 2"]
        XCTAssertTrue(firstItem.waitForExistence(timeout: 5))
        XCTAssertTrue(secondItem.waitForExistence(timeout: 5))
        
        sleep(1)
        
        // Perform reorder gesture
        firstItem.press(forDuration: 0.5, thenDragTo: secondItem)
        
        // Wait for reorder to complete
        sleep(1)
        
        // Verify order
        let cells = app.collectionViews.cells
        XCTAssertTrue(cells.element(boundBy: 0).staticTexts["Test Item 2"].exists)
        XCTAssertTrue(cells.element(boundBy: 1).staticTexts["Test Item"].exists)
    }
}
