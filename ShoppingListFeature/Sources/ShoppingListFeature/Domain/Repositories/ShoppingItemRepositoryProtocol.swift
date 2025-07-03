//
//  ShoppingItemRepositoryProtocol.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine

protocol ShoppingItemRepositoryProtocol {
    func addShoppingItem(shopItem: ShoppingListItemEntity) async throws
    func getShoppingListItems(_ filter: ShoppingListFilter) async throws -> [ShoppingListItemEntity]
    func updateShoppingItem(item: ShoppingListItemEntity) async throws
    func deleteShoppingItem(id: String) async throws
    func observeShoppingListItems(_ filter: ShoppingListFilter) -> AnyPublisher<[ShoppingListItemEntity], Error>
}


enum ShoppingListFilter {
    enum ShoppingListPurchaseStatusFilter {
        case all
        case purchased
        case notPurchased
    }
    
    case filter(purchaseStatus: ShoppingListPurchaseStatusFilter, searchText: String)
}
