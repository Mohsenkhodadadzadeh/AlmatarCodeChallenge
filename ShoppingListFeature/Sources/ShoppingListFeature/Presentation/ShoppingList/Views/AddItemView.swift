//
//  AddItemSheetView.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import SwiftUI

struct AddItemView: View {
    @StateObject var viewModel: AddItemViewModel
    
    init(viewModel: AddItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Form {
                Section("Item Details") {
                    TextField("Item Name (required)", text: $viewModel.itemName)
                    Stepper("Quantity \(viewModel.itemQuantity)", value: $viewModel.itemQuantity, in: 0...100)
                    TextField("Note (Optional)", text: $viewModel.itemNote)
                }
            }
            Spacer()
            
            Button {
                viewModel.addItem()
            } label: {
                Text("Save")
                    .font(.title)
                    .foregroundStyle(.background)
                    
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.vertical, 10)
                    
                    
            }
            .opacity(viewModel.showSaveButton ? 1 : 0)
            .animation(.easeOut(duration: 0.8), value: viewModel.showSaveButton)
        }
        
        
       
    }
}

#Preview {
    AddItemView(viewModel: ShoppingListModuleFactory().makeAddItemViewModel(coordinator: nil))
}
