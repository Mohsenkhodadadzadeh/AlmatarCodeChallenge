//
//  ShoppintLIstItem.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/2/25.
//

import Foundation
import SwiftData

extension DBModel {
    @Model final class ShoppingListItem {
        var id: UUID
        var name: String
        var quantity: Int
        var note: String?
        var didPurchase: Bool
        init(id: UUID = UUID(), name: String = "", quantity: Int = 0, note: String? = nil, didPurchase: Bool = false) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.note = note
            self.didPurchase = didPurchase
        }
    }
}
