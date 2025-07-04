//
//  GetShoppingItemsUseCase.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation
import Combine

public class GetShoppingItemsUseCase {
    private let repositoty: ShoppingItemRepositoryProtocol
    
    init(repositoty: ShoppingItemRepositoryProtocol) {
        self.repositoty = repositoty
    }
    
    public func execute(_ filter: ShoppingListFilter) async throws -> [ShoppingListItemEntity] {
        try await repositoty.getShoppingListItems(filter)
    }
    
    public func observe(_ filter: ShoppingListFilter) -> AnyPublisher<[ShoppingListItemEntity], Error> {
        return repositoty.observeShoppingListItems(filter).eraseToAnyPublisher()
    }
}

