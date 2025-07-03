//
//  InMemoryShoppingListItemDataStorage.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine
import SwiftData
import SwiftUICore

public final class InMemoryShoppingListItemDataStorage: LocalShoppingDataStorageProtocol {
    
    private let modelContainer: ModelContainer
   
    private var modelContext: ModelContext {
        ModelContext(modelContainer)
    }
    
    private var itemsSubject: CurrentValueSubject<[DBModel.ShoppingListItem], Error> = .init([])
    private var items: [DBModel.ShoppingListItem] = [] {
        didSet {
            itemsSubject.send(items)
        }
    }
    init (modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        
    }
    
    public func createOrUpdate(_ item: DBModel.ShoppingListItem) async throws {
        let context = modelContext
      
        do {
            let descriptor = FetchDescriptor<DBModel.ShoppingListItem>(predicate: #Predicate { $0.id == item.id})
            if let existingItem = try context.fetch(descriptor).first {
                existingItem.name = item.name
                existingItem.quantity = item.quantity
                existingItem.note = item.note
                existingItem.didPurchase = item.didPurchase
                existingItem.updatedAt = Date()
            } else {
                let newItem = DBModel.ShoppingListItem(
                    id: item.id,
                    name: item.name,
                    quantity: item.quantity,
                    note: item.note,
                    didPurchase: item.didPurchase,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                context.insert(newItem)
            }
            try context.save()
            await notifyObserver()
        }
    }
    
    public func fetchAll() async throws -> [DBModel.ShoppingListItem] {
        let context = modelContext
        
        do {
            let descriptor = FetchDescriptor<DBModel.ShoppingListItem>()
            let items = try context.fetch(descriptor)
            return items
        } catch {
            print("SwiftData Local Scorage Error: \(error)")
            throw error
        }
    }
    
    public func delete(_ id: UUID) async throws {
        let context = modelContext
        
        do {
            let descriptor = FetchDescriptor<DBModel.ShoppingListItem>(predicate: #Predicate { $0.id == id})
            if let itemToDelete = try context.fetch(descriptor).first {
                context.delete(itemToDelete)
                try context.save()
                
                await notifyObserver()
            }
        } catch {
            print("SwiftData Local Scorage Error: \(error)")
            throw error
        }
    }
    
    public func observeChanges() -> AnyPublisher<[DBModel.ShoppingListItem], any Error> {
        
        return itemsSubject.eraseToAnyPublisher()
    }
    
    private func notifyObserver() async {
        do {
            let latestItems = try await fetchAll()
            itemsSubject.send(latestItems)
        } catch {
            itemsSubject.send(completion: .failure(error))
        }
    }
}

