//
//  AddShoppingItemUseCase.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//


import Foundation

public class AddShoppingItemUseCase {
    
    private let repository: ShoppingItemRepositoryProtocol
    
    init(repository: ShoppingItemRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(name: String, note: String? = nil, quantity: Int, isPurchased: Bool) async throws {
        let newItem = ShoppingListItemEntity(id: UUID(), name: name, quantity: quantity, note: note, didPurchase: isPurchased, createdAt: Date())
        print("Use case adding shopping item \(newItem)")
        try await repository.addShoppingItem(shopItem: newItem)
    }
    
    
}
