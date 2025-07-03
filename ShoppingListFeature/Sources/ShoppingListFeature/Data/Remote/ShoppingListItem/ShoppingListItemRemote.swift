//
//  ShoppingListItemRemote.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation


extension ApiModel {
   
    struct ShoppingListItemRemote: Codable {
        let id: String
        var name: String
        var quantity: Int
        var note: String?
        var didPurchase: Bool
    }
    
}


