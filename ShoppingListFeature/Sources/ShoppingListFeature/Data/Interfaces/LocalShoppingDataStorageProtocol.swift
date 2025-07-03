//
//  LocalShoppingDataStorageProtocol.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine

public protocol LocalShoppingDataStorageProtocol: AnyObject {
    
    func createOrUpdate(_ item: DBModel.ShoppingListItem) async throws
    
    func fetchAll() async throws -> [DBModel.ShoppingListItem]
    
    func delete(_ id: UUID) async throws
    
    func observeChanges() -> AnyPublisher<[DBModel.ShoppingListItem], Error>
    
}

