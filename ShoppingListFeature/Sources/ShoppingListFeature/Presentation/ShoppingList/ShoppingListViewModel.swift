//
//  ShoppingListViewModel.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation
import Combine


public final class ShoppingListViewModel: ObservableObject {
    
    @Published var items: [ShoppingListItemEntity] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var showOnlyNotPurchasedItems: Bool = false
    private weak var coordinator: MainCoordinator?
    private var deleteShoopingItemUseCase: DeleteShoppingItemUseCase
    private var updateShoppingItemUseCase: UpdateShoppingItemUseCase
    private var getShoppingItemsUseCase: GetShoppingItemsUseCase
    
    private var cancellables: Set<AnyCancellable> = []
    init(getShoppingItemsUseCase:GetShoppingItemsUseCase, deleteShoppingItemUseCase: DeleteShoppingItemUseCase, updateShoppingItemUseCase: UpdateShoppingItemUseCase, coordinator: MainCoordinator?) {
        self.getShoppingItemsUseCase = getShoppingItemsUseCase
        self.deleteShoopingItemUseCase = deleteShoppingItemUseCase
        self.updateShoppingItemUseCase = updateShoppingItemUseCase
        self.coordinator = coordinator
        observeChanges()
    }
    
    func observeChanges() {
        getShoppingItemsUseCase.observe(.filter(purchaseStatus: self.showOnlyNotPurchasedItems ? .notPurchased : .all, searchText: self.searchText))
            .sink { completion in
                
            } receiveValue: { [weak self] items in
                print("comes with publisher \(items.count)")
                self?.items = items
            }
            .store(in: &cancellables)

    }
    
    @MainActor
    func togglePurchaseStatus(for item: ShoppingListItemEntity) {
        let useCase = updateShoppingItemUseCase
        var updatedItem = item
        updatedItem.didPurchase.toggle()
        Task { [weak self] in
            do {
                try await useCase.execute(item: updatedItem)
                self?.getShoppingItems()
            } catch {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor func deleteItem(for item: ShoppingListItemEntity) {
        let useCase = deleteShoopingItemUseCase
        Task { [weak self] in
            do {
                try await useCase.execute(id: item.id)
            } catch {
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func getShoppingItems() {
        let useCase = getShoppingItemsUseCase
        let filter: ShoppingListFilter = .filter(purchaseStatus: self.showOnlyNotPurchasedItems ? .notPurchased : .all, searchText: self.searchText)
        Task {
            do {
                
                self.items = try await useCase.execute(filter)
                print("Item counts: \(items.count)")
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor func addAnItem() {
        coordinator?.addANewShoppingItem()
    }
}
