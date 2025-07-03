//
//  ShoppintLIstItem.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/2/25.
//

import Foundation
import SwiftData

extension DBModel {
    
    @Model public final class ShoppingListItem: Codable, Identifiable {
        
        @Attribute(.unique) public var id: UUID
        public var name: String
        public var quantity: Int
        public var note: String?
        public var didPurchase: Bool
        public var createdAt: Date
        public var updatedAt: Date?
        
        public init(id: UUID = UUID(), name: String = "", quantity: Int = 0, note: String? = nil, didPurchase: Bool = false, createdAt: Date = Date(), updatedAt: Date? = nil) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.note = note
            self.didPurchase = didPurchase
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.quantity = try container.decode(Int.self, forKey: .quantity)
            self.note = try container.decodeIfPresent(String.self, forKey: .note)
            self.didPurchase = try container.decode(Bool.self, forKey: .didPurchase)
            self.createdAt = try container.decode(Date.self, forKey: .createdAt)
            self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(quantity, forKey: .quantity)
            try container.encodeIfPresent(note, forKey: .note)
            try container.encode(didPurchase, forKey: .didPurchase)
            try container.encode(createdAt, forKey: .createdAt)
            try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        }
        
        enum CodingKeys: String, CodingKey {
           case id
            case name
            case quantity
            case note
            case didPurchase
            case createdAt
            case updatedAt
        }
    }
}
