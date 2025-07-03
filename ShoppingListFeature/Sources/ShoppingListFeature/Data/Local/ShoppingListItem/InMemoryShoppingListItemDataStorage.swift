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
    private let shoppingListItemMapper: ShoppingListItemMapper
    private var modelContext: ModelContext {
        ModelContext(modelContainer)
    }
    
    private var itemsSubject: CurrentValueSubject<[ShoppingListItemEntity], Error> = .init([])
    private var items: [ShoppingListItemEntity] = [] {
        didSet {
            itemsSubject.send(items)
        }
    }
    init (modelContainer: ModelContainer, shoppingListItemMapper: ShoppingListItemMapper = ShoppingListItemMapper()) {
        self.modelContainer = modelContainer
        self.shoppingListItemMapper = shoppingListItemMapper
        
    }
    
    public func createOrUpdate(_ item: ShoppingListItemEntity) async throws {
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
    
    public func fetchAll() async throws -> [ShoppingListItemEntity] {
        let context = modelContext
        
        do {
            let descriptor = FetchDescriptor<DBModel.ShoppingListItem>()
            let items = try context.fetch(descriptor)
            let returnObject = items.compactMap({ item in
                let entity = shoppingListItemMapper.toLocalDomain(from: item)
                return entity
            })
            return returnObject
        } catch {
            print("SwiftData Local Scorage Error: \(error)")
            throw error
        }
    }
    
    public func delete(_ item: ShoppingListItemEntity) async throws {
        let context = modelContext
        
        do {
            let descriptor = FetchDescriptor<DBModel.ShoppingListItem>(predicate: #Predicate { $0.id == item.id})
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
    
    public func observeChanges() -> AnyPublisher<[ShoppingListItemEntity], any Error> {
        
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

