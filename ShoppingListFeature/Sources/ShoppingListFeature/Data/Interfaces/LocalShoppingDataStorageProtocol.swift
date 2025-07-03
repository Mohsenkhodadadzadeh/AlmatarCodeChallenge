//
//  LocalShoppingDataStorageProtocol.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine

public protocol LocalShoppingDataStorageProtocol: AnyObject {
    
    func createOrUpdate(_ item: ShoppingListItemEntity) async throws
    
    func fetchAll() async throws -> [ShoppingListItemEntity]
    
    func delete(_ item: ShoppingListItemEntity) async throws
    
    func observeChanges() -> AnyPublisher<[ShoppingListItemEntity], Error>
    
}
