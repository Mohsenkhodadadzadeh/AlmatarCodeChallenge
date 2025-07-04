//
//  AddItemViewModel.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation
import Combine

public final class AddItemViewModel: ObservableObject {
    
    private weak var coordinator: MainCoordinator?
    
    var addShoppingItemUseCase: AddShoppingItemUseCase
    
    @Published var itemName: String = ""
    @Published var itemQuantity: Int = 1
    @Published var itemNote: String = ""
    @Published var showSaveButton: Bool = false
    private var cancellables = Set<AnyCancellable>()
    init(addShoppingItemUseCase: AddShoppingItemUseCase, coordinator: MainCoordinator?) {
        self.coordinator = coordinator
        self.addShoppingItemUseCase = addShoppingItemUseCase
        observeChanges()
    }
    
    private func observeChanges() {
        $itemName
            .combineLatest($itemQuantity)
            .sink {[weak self] (name, quantity) in
                self?.showSaveButton = !(name.isEmpty || quantity == 0)
            }
            .store(in: &cancellables)
    }
    @MainActor
    func addItem() {
        let useCase = addShoppingItemUseCase
        Task {
            do {
                try await useCase.execute(name: itemName, note: itemNote.isEmpty ? nil : itemNote, quantity: itemQuantity, isPurchased: false)
                self.goBack()
            } catch {
                print("error \(error)")
            //    searchText = "error \(error.localizedDescription)"
            }
        }
        
    }
    
    @MainActor func goBack() {
        coordinator?.goBack()
    }
    
}
