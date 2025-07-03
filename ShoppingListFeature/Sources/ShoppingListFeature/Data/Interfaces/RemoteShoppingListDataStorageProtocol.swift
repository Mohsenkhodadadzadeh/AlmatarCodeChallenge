//
//  RemoteShoppingListDataStorageProtocol.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation
import Combine

public protocol RemoteShoppingListDataStorageProtocol: AnyObject {
    
    func upload(_ item: ApiModel.ShoppingListItemRemote) async throws
    
    func updateRemote(_ item: ApiModel.ShoppingListItemRemote) async throws
    
    func deleteRemote(_ id: String) async throws
    
    func downloadAll() async throws -> [ApiModel.ShoppingListItemRemote]
}
