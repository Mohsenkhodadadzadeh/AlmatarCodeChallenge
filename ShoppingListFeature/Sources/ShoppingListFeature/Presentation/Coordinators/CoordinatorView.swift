//
//  CoordinatorView.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import SwiftUI

public struct CoordinatorView: View {
    
    @StateObject public var coordinator = MainCoordinator()
    
    public init() {
   
    }
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeView(for: .shoppingList)
                .navigationDestination(for: Page.self) { page in
                    coordinator.makeView(for: page)
                }
        }
    }
}

#Preview {
    CoordinatorView()
}
