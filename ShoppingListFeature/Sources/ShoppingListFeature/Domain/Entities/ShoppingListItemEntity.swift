//
//  ShoppingListItemEntity.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation

public struct ShoppingListItemEntity: Codable, Sendable, Equatable {
    let id: UUID
    var name: String
    var quantity: Int
    var note: String?
    var didPurchase: Bool
    var createdAt: Date
    var updatedAt: Date?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.quantity == rhs.quantity &&
        lhs.note == rhs.note &&
        lhs.didPurchase == rhs.didPurchase &&
        lhs.createdAt == rhs.createdAt
    }
}
