//
//  ShoppingItemRepositoryTests.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import XCTest
import Combine
@testable import ShoppingListFeature

final class ShoppingItemRepositoryTests: XCTestCase {
    
    var mockLocalDataSource: MockLocalShoppingItemDataSource!
    var mockRemoteDataSource: MockRemoteShoppingItemDataSource!
    var shoppingListMapper: ShoppingListItemMapper!
    var repository: ShoppingListItemRepository!
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockLocalDataSource = MockLocalShoppingItemDataSource()
        mockRemoteDataSource = MockRemoteShoppingItemDataSource()
        shoppingListMapper = ShoppingListItemMapper()
        repository = ShoppingListItemRepository(
            localDataSource: mockLocalDataSource,
            remoteDataSource: mockRemoteDataSource,
            shoppingListItemMapper: shoppingListMapper
        )
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockLocalDataSource = nil
        mockRemoteDataSource = nil
        shoppingListMapper = nil
        repository = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Test Cases
    
    func testFetchShoppingItems_ReturnsLocalDataImmediatelyAndTriggersSync() async throws {
        // Given initial local data
        let item1 = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let item2 = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let mappedItem1 = shoppingListMapper.localToData(from: item1)!
        let mappedItem2 = shoppingListMapper.localToData(from: item2)!
        
        mockLocalDataSource.items = [mappedItem1, mappedItem2]
        
        // When fetching items
        let fetchedItems = try await repository.getShoppingListItems(.filter(purchaseStatus: .all, searchText: ""))
        
        // Then local data is returned immediately
        XCTAssertEqual(fetchedItems.count, 2)
        XCTAssertEqual(fetchedItems.first?.id ?? UUID(), item1.id)
        
    }
    
    func testAddShoppingItem_SavesLocallyAndQueuesForUpload() async throws {
        // Given a new item
        let newItem = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        // When adding the item
        try await repository.addShoppingItem(shopItem: newItem)
        
        // Then it's saved locally
        XCTAssertEqual(mockLocalDataSource.createOrUpdateCalledCount, 1)
        let localItems = try await mockLocalDataSource.fetchAll()
        XCTAssertTrue(localItems.contains(where: { $0.id == newItem.id }))
        
    }
    
    func testUpdateShoppingItem_UpdatesLocallyAndQueuesForUpdate() async throws {
        // Given an existing item
        let existingItem = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let mappedExistingItem = shoppingListMapper.localToData(from: existingItem)!
        mockLocalDataSource.items = [mappedExistingItem]
        
        // When updating the item
        var updatedItem = existingItem
        updatedItem.name = "Updated Item"
        updatedItem.quantity = 5
        try await repository.updateShoppingItem(item: updatedItem)
        
        // Then it's updated locally
        XCTAssertEqual(mockLocalDataSource.createOrUpdateCalledCount, 1)
        let localItems = try await mockLocalDataSource.fetchAll()
        XCTAssertEqual(localItems.first?.name, "Updated Item")
        XCTAssertEqual(localItems.first?.quantity, 5)
        
    }
    
    func testDeleteShoppingItem_DeletesLocallyAndQueuesForDelete() async throws {
        // Given an existing item
        let itemToDelete = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let mappedItemToDelete = shoppingListMapper.localToData(from: itemToDelete)!
        
        mockLocalDataSource.items = [mappedItemToDelete]
        
        // When deleting the item
        try await repository.deleteShoppingItem(id: itemToDelete.id)
        
        // Then it's deleted locally
        XCTAssertEqual(mockLocalDataSource.deleteCalledCount, 1)
        let localItems = try await mockLocalDataSource.fetchAll()
        XCTAssertTrue(localItems.isEmpty)
        
    }
    
    func testObserveShoppingItems_EmitsUpdatesFromLocalDataSource() async throws {
        // Given Data
        let item1 = ShoppingListItemEntity(
            id: UUID(),
            name: "New Observed Item",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let item2 = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let mappedItem1 = shoppingListMapper.localToData(from: item1)!
        let mappedItem2 = shoppingListMapper.localToData(from: item2)!
        
        try await mockLocalDataSource.createOrUpdate(mappedItem1)
        try await mockLocalDataSource.createOrUpdate(mappedItem2)
        
        
        // Given a subscriber
        var receivedItems: [ShoppingListItemEntity] = []
        
        repository.observeShoppingListItems(.filter(purchaseStatus: .all, searchText: ""))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Observer completed with error: \(error)")
                }
            }, receiveValue: { items in
                receivedItems.append(contentsOf: items)
                XCTAssertEqual(receivedItems.count, 3)
                
            })
            .store(in: &cancellables)
        
        
        // When local data changes (simulated by the mock data source)
        let newItem = ShoppingListItemEntity(
            id: UUID(),
            name: "test Item 1",
            quantity: 1,
            note: "",
            didPurchase: false,
            createdAt: Date()
        )
        
        let mappedNewItem = shoppingListMapper.localToData(from: newItem)!
        
        try await mockLocalDataSource.createOrUpdate(mappedNewItem)
        
        
        // Wait for the second emission
        let updatedExpectation = XCTestExpectation(description: "Updated shopping items observed")
        
        XCTAssertEqual(receivedItems.count, 3)
        XCTAssertEqual(receivedItems.contains(where: { $0.id == newItem.id}), true)
        XCTAssertEqual(receivedItems.first!.name, "New Observed Item")
    }
    
}
