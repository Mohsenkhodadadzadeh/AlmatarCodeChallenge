//
//  ShoppingListModuleFactory.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation
import SwiftUI
import SwiftData

public final class ShoppingListModuleFactory {
    
    public init() {
        
    }
    
    private func makeLocalDataSource() -> LocalShoppingDataStorageProtocol {
        do {
            let schema = Schema([DBModel.ShoppingListItem.self])
            
            let modelConfiguration = ModelConfiguration(schema: schema)
            
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            return InMemoryShoppingListItemDataStorage(modelContainer: container)
        } catch {
            fatalError("something went wrong: \(error)")
        }
        
    }
    
    private func makeRemoteDataSource() -> RemoteShoppingListDataStorageProtocol {
        // For now, we use the mock remote data source from Phase 2
        return MockRemoteShoppingListDataStorage()
    }
    
    private func shoppingListItemMapper() -> ShoppingListItemMapper {
        return ShoppingListItemMapper()
    }
    private func makeShoppingItemRepository() -> ShoppingItemRepositoryProtocol {
        return ShoppingListItemRepository(
            localDataSource: makeLocalDataSource(),
            remoteDataSource: makeRemoteDataSource(),
            shoppingListItemMapper: shoppingListItemMapper()
        )
    }
    
    private func makeAddShoppingListItemUseCase() -> AddShoppingItemUseCase {
        return AddShoppingItemUseCase(repository: makeShoppingItemRepository())
    }
    
    private func makeGetShoppingItemsUseCase() -> GetShoppingItemsUseCase {
        return GetShoppingItemsUseCase(repositoty: makeShoppingItemRepository())
    }
    
    private func makeDeleteShoppingItemUseCase() -> DeleteShoppingItemUseCase {
        return DeleteShoppingItemUseCase(repository: makeShoppingItemRepository())
    }
    
    private func updateShoppingItemUseCase() -> UpdateShoppingItemUseCase {
        return UpdateShoppingItemUseCase(repository: makeShoppingItemRepository())
    }
    
    internal func makeShoppingListViewModel(coordinator: MainCoordinator?) -> ShoppingListViewModel {
        return ShoppingListViewModel(getShoppingItemsUseCase: makeGetShoppingItemsUseCase(), deleteShoppingItemUseCase: makeDeleteShoppingItemUseCase(), updateShoppingItemUseCase: updateShoppingItemUseCase(), coordinator: coordinator)
    }
    
    @MainActor public func makeShoppingListView(coordinator: MainCoordinator?) -> some View {
        let viewModel = makeShoppingListViewModel(coordinator: coordinator)
        viewModel.getShoppingItems()
        return ShoppingListView(viewModel: viewModel)
    }
    
    internal func makeAddItemViewModel(coordinator: MainCoordinator?) -> AddItemViewModel {
        return AddItemViewModel(addShoppingItemUseCase: makeAddShoppingListItemUseCase(), coordinator: coordinator)
    }
    
    @MainActor internal func makeAddItemView(coordinator: MainCoordinator?) -> some View {
        let viewModel = makeAddItemViewModel(coordinator: coordinator)
        
        return AddItemView(viewModel: viewModel)
    }
    
}
