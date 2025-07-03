//
//  ShoppingListItemEntity.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation

struct ShoppingListItemEntity: Codable {
    let id: UUID
    var name: String
    var quantity: Int
    var note: String?
    var didPurchase: Bool
}
