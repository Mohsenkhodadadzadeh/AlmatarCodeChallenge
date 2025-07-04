//
//  DeleteShoppingItemUseCase.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation

class DeleteShoppingItemUseCase {
    private let repository: ShoppingItemRepositoryProtocol
    
    init(repository: ShoppingItemRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws {
        try await repository.deleteShoppingItem(id: id)
    }
}
