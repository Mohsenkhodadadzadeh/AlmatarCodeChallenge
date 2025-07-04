//
//  UpdateShoppingItemUseCase.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation

public class UpdateShoppingItemUseCase {
    private let repository: ShoppingItemRepositoryProtocol
    
    init(repository: ShoppingItemRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(item: ShoppingListItemEntity) async throws {
        try await repository.updateShoppingItem(item: item)
    }
}
