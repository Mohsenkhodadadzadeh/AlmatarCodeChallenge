//
//  ShoppingLIstItemrepository.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine

public class ShoppingListItemRepository: ShoppingItemRepositoryProtocol {
    
    private let localDataSource: LocalShoppingDataStorageProtocol
    private let remoteDataSource: RemoteShoppingListDataStorageProtocol
    private let shoppingListItemMapper: ShoppingListItemMapper
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init(localDataSource: LocalShoppingDataStorageProtocol,
                remoteDataSource: RemoteShoppingListDataStorageProtocol,
                shoppingListItemMapper: ShoppingListItemMapper) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.shoppingListItemMapper = shoppingListItemMapper
    }
    
    
    
    func addShoppingItem(shopItem: ShoppingListItemEntity) async throws {
        
        guard let localModel = shoppingListItemMapper.localToData(from: shopItem) else {
            throw (NSError(domain: "Mapping Entity to Local Model Failed", code: -1))
        }
        try await localDataSource.createOrUpdate(localModel)
        
        guard let remoteModel = shoppingListItemMapper.remoteToData(from: shopItem) else {
            throw NSError(domain: "Mapping Entity to Remote Model Failed", code: -1)
        }
        try await remoteDataSource.upload(remoteModel)
    }
    
    func getShoppingListItems(_ filter: ShoppingListFilter) async throws -> [ShoppingListItemEntity] {
        let items = try await localDataSource.fetchAll()
        
        var result: [ShoppingListItemEntity] = []
        for item in items {
            guard let entity = shoppingListItemMapper.toLocalDomain(from: item) else {
                continue
            }
            result.append(entity)
        }
        return result
    }
    
    func updateShoppingItem(item: ShoppingListItemEntity) async throws {
        
        guard let localModel = shoppingListItemMapper.localToData(from: item) else {
            throw NSError(domain: "Mapping Entity to Local Model Failed", code: -1)
        }
        
        _ = try await localDataSource.createOrUpdate(localModel)
        
        guard let remoteModel = shoppingListItemMapper.remoteToData(from: item) else {
            throw NSError(domain: "Mapping Entity to Remote Model Failed", code: -1)
        }
        
        try await remoteDataSource.updateRemote(remoteModel)
    }
    
    func deleteShoppingItem(id: UUID) async throws {

        try await localDataSource.delete(id)
        
        try await remoteDataSource.deleteRemote(id.uuidString)
    }
    
    func observeShoppingListItems(_ filter: ShoppingListFilter) -> AnyPublisher<[ShoppingListItemEntity], any Error> {
        
        return localDataSource.observeChanges()
            .tryMap({[weak self] items in
                print("Received in Repo")
                var mappedItems: [ShoppingListItemEntity] = []
                
                for item in items {
                    guard let mappedItem = self?.shoppingListItemMapper.toLocalDomain(from: item) else {
                        continue
                    }
                    mappedItems.append(mappedItem)
                    
                }
             return mappedItems
            })
            .eraseToAnyPublisher()
    }
    
    
}

