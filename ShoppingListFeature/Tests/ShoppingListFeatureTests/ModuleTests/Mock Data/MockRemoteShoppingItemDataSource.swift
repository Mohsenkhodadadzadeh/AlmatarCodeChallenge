//
//  MockRemoteShoppingItemDataSource.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/3/25.
//

import XCTest
import Combine
@testable import ShoppingListFeature

final class MockRemoteShoppingItemDataSource: RemoteShoppingListDataStorageProtocol {
    
    // Simulate remote operations
       var uploadCalledCount = 0
       var updateRemoteCalledCount = 0
       var deleteRemoteCalledCount = 0
       var downloadAllCalledCount = 0

    func upload(_ item: ApiModel.ShoppingListItemRemote) async throws {
           uploadCalledCount += 1
       }

    func updateRemote(_ item: ApiModel.ShoppingListItemRemote) async throws {
           updateRemoteCalledCount += 1
       }

    func deleteRemote(_ id: String) async throws {
           deleteRemoteCalledCount += 1
       }

    func downloadAll() async throws -> [ApiModel.ShoppingListItemRemote] {
           downloadAllCalledCount += 1
           return [] // Return empty for basic tests unless you need specific mock data
       }
}
