//
//  MockLocalShoppingItemDataSource.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import XCTest
import Combine
@testable import ShoppingListFeature

class MockLocalShoppingItemDataSource: LocalShoppingDataStorageProtocol {
    
    var items: [DBModel.ShoppingListItem] = [] // Internal store for testing
    let subject = PassthroughSubject<[DBModel.ShoppingListItem], Error>() // Used to simulate changes
    
    // Track method calls
    var createOrUpdateCalledCount = 0
    var fetchAllCalledCount = 0
    var deleteCalledCount = 0
    
    func createOrUpdate(_ item: DBModel.ShoppingListItem) async throws {
        createOrUpdateCalledCount += 1
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item // Simulate update
        } else {
            items.append(item) // Simulate create
        }
        subject.send(items) // Emit change
    }
    
    func fetchAll() async throws -> [DBModel.ShoppingListItem] {
        fetchAllCalledCount += 1
        return items
    }
    
    func delete(_ id: UUID) async throws {
        deleteCalledCount += 1
        items.removeAll(where: { $0.id == id })
        subject.send(items) // Emit change
    }
    
    func observeChanges() -> AnyPublisher<[DBModel.ShoppingListItem], Error> {
        return subject.eraseToAnyPublisher()
    }
}
