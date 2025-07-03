//
//  MockRemoteShoppingListDataStorage.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import Foundation


public class MockRemoteShoppingListDataStorage: RemoteShoppingListDataStorageProtocol {
    
    public func upload(_ item: ApiModel.ShoppingListItemRemote) async throws {
        
        try await Task.sleep(nanoseconds: 5_000_000)
        print("remote uploaded")
    }
    
    public func updateRemote(_ item: ApiModel.ShoppingListItemRemote) async throws {
        try await Task.sleep(nanoseconds: 5_000_000)
        print("remote updated")
    }
    
    public func deleteRemote(_ id: String) async throws {
        
        try await Task.sleep(nanoseconds: 5_000_000)
        print("remote deleted")
    }
    
    public func downloadAll() async throws -> [ApiModel.ShoppingListItemRemote] {
        try await Task.sleep(nanoseconds: 5_000_000)
        
        let remoteItems = [
            ApiModel.ShoppingListItemRemote(
                id: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
                name: "test item 1",
                quantity: 2,
                didPurchase: false,
                createdAt:  Date().addingTimeInterval(-86400)
            ),
            ApiModel.ShoppingListItemRemote(
                id: "D12A4F0B-6E3A-4F8A-8C2A-0A7C1E8A9B0C",
                name: "test item 2",
                quantity: 2,
                didPurchase: true,
                createdAt:  Date().addingTimeInterval(-172800),
                updatedAt: Date().addingTimeInterval(-86400)
            ),
            ApiModel.ShoppingListItemRemote(
                id: "C3A5B8D1-9F2B-4A7C-8E1A-0B9D6C5A4E3F",
                name: "test item 3",
                quantity: 2,
                didPurchase: false,
                createdAt:  Date().addingTimeInterval(-3600)
            )
        ]
        
        return remoteItems
    }
    
    
}
