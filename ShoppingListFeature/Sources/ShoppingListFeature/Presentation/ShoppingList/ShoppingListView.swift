//
//  SwiftUIView.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import SwiftUI

struct ShoppingListView: View {
    
    @StateObject private var viewModel: ShoppingListViewModel
    
    @State private var showAddItemSheet: Bool = false
   // @State private var : Bool = false
    @State private var showingSortOptions: Bool = false
    @State private var showingAddItemSheet: Bool = false
    init(viewModel: ShoppingListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.vertical, 5)
            }
            
            if viewModel.isLoading {
                ProgressView("Loading Items...")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            else if viewModel.items.isEmpty && viewModel.searchText.isEmpty {
                Text("No shopping items yet. Tap `+` to add one!")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
            } else if viewModel.items.isEmpty && !viewModel.searchText.isEmpty {
                Text("No result for \(viewModel.searchText)")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(viewModel.items, id: \.id) { item in
                    ItemRowView(item: item) {
                             viewModel.togglePurchaseStatus(for: item)
                        
                    } deleteAction: {
                        viewModel.deleteItem(for: item)
                    }
                }
            }
        }
        .navigationTitle("Shopping List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        viewModel.showOnlyNotPurchasedItems.toggle()
                    } label: {
                        Image(systemName: showAddItemSheet ? "eye.fill" : "eye.slash.fill")
                            .symbolRenderingMode(.multicolor)
                        
                    }
                    
                    Button {
                        showingSortOptions = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .symbolRenderingMode(.multicolor)
                    }
                    .sheet(isPresented: $showingSortOptions) {
                        Text("Will be Implemented Soon")
                    }
                    
                    Button {
                        viewModel.addAnItem()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "search Items or Notes")
     
                    .onAppear {
                        viewModel.getShoppingItems()
                        
                    }
        
    }
}

#Preview {
    ShoppingListView(viewModel: ShoppingListModuleFactory().makeShoppingListViewModel(coordinator: nil))
}
