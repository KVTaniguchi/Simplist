
import XCTest
@testable import Simplist
import SwiftData

@MainActor
final class SimplistTests: XCTestCase {
    // MARK: - Properties
    private var container: ModelContainer!
    private var context: ModelContext!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        // Create an in-memory container for testing
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        context = container.mainContext
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        context = nil
        container = nil
    }
    
    // MARK: - Helper Methods
    private func createTestItem(name: String = "Test Item", ordinal: Int = 1) -> Item {
        let item = Item()
        item.name = name
        item.ordinal = ordinal
        return item
    }
    
    private func saveContext() throws {
        try context.save()
    }
    
    // MARK: - Test Cases
    func testItemInitialState() throws {
        // Given
        let item = createTestItem()
        
        // Then
        XCTAssertNotNil(item.timestamp)
        XCTAssertEqual(item.name, "Test Item")
        XCTAssertEqual(item.ordinal, 1)
        XCTAssertFalse(item.completed)
        XCTAssertNotNil(item.uuid)
        XCTAssertFalse(item.uuid.isEmpty)
    }
    
    func testItemCreationAndPersistence() throws {
        // Given
        let item = createTestItem()
        
        // When
        context.insert(item)
        try saveContext()
        
        // Then
        let descriptor = FetchDescriptor<Item>()
        let fetchedItems = try context.fetch(descriptor)
        XCTAssertEqual(fetchedItems.count, 1)
        XCTAssertEqual(fetchedItems[0].name, "Test Item")
    }
    
    func testItemUpdate() throws {
        // Given
        let item = createTestItem()
        context.insert(item)
        try saveContext()
        
        // When
        item.name = "Updated Name"
        item.ordinal = 2
        try saveContext()
        
        // Then
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate<Item> { item in
            item.uuid == item.uuid
        })
        let fetchedItems = try context.fetch(descriptor)
        XCTAssertEqual(fetchedItems.count, 1)
        XCTAssertEqual(fetchedItems[0].name, "Updated Name")
        XCTAssertEqual(fetchedItems[0].ordinal, 2)
    }
    
    func testItemCompletion() throws {
        // Given
        let item = createTestItem()
        context.insert(item)
        try saveContext()
        
        // When
        item.completed = true
        try saveContext()
        
        // Then
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate<Item> { item in
            item.uuid == item.uuid
        })
        let fetchedItems = try context.fetch(descriptor)
        XCTAssertEqual(fetchedItems.count, 1)
        XCTAssertTrue(fetchedItems[0].completed)
    }
    
    func testItemDeletion() throws {
        // Given
        let item = createTestItem()
        context.insert(item)
        try saveContext()
        
        // When
        context.delete(item)
        try saveContext()
        
        // Then
        let descriptor = FetchDescriptor<Item>(predicate: #Predicate<Item> { item in
            item.uuid == item.uuid
        })
        let fetchedItems = try context.fetch(descriptor)
        XCTAssertEqual(fetchedItems.count, 0)
    }
    
    func testMultipleItemsOrdering() throws {
        // Given
        let item1 = createTestItem(name: "First Item", ordinal: 1)
        let item2 = createTestItem(name: "Second Item", ordinal: 2)
        let item3 = createTestItem(name: "Third Item", ordinal: 3)
        
        // When
        context.insert(item1)
        context.insert(item2)
        context.insert(item3)
        try saveContext()
        
        // Then
        let descriptor = FetchDescriptor<Item>()
        let fetchedItems = try context.fetch(descriptor)
        XCTAssertEqual(fetchedItems.count, 3)
        
        // Verify order
        let sortedItems = fetchedItems.sorted { $0.ordinal ?? 0 < $1.ordinal ?? 0 }
        XCTAssertEqual(sortedItems[0].name, "First Item")
        XCTAssertEqual(sortedItems[1].name, "Second Item")
        XCTAssertEqual(sortedItems[2].name, "Third Item")
    }
    
    func testEmptyItemName() throws {
        // Given
        let item = Item()
        
        // Then
        XCTAssertNil(item.name)
        XCTAssertFalse(item.completed)
        XCTAssertNotNil(item.timestamp)
        XCTAssertNotNil(item.uuid)
    }
    
    func testItemTimestamp() throws {
        // Given
        let item = createTestItem()
        let creationTime = Date()
        
        // Then
        XCTAssertNotNil(item.timestamp)
        XCTAssertLessThanOrEqual(item.timestamp.timeIntervalSince(creationTime), 1.0)
    }
}
