//
//  MainCoordinator.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import Foundation
import SwiftUI

@MainActor
public final class MainCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    private var diFactory: ShoppingListModuleFactory = ShoppingListModuleFactory()
    func addANewShoppingItem() {
        path.append(Page.addItem)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func goHome() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func makeView(for page: Page) -> some View {
        switch page {
        case .shoppingList:
            diFactory.makeShoppingListView(coordinator: self)
        case .addItem:
            diFactory.makeAddItemView(coordinator: self)

        }
    }
}
