//
//  SwiftUIView.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//

import SwiftUI

struct ItemRowView: View {
    let item: ShoppingListItemEntity
    let toggleAction: () -> Void
    let deleteAction: () -> Void
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.didPurchase, pattern: .solid, color: .gray)
                
                Text("Qty: \(item.quantity)")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                
                if let note = item.note {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: item.didPurchase ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(item.didPurchase ? .green : .gray)
                .onTapGesture(perform: toggleAction)
            }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }

        }
        
    }
}

#Preview {
    ItemRowView(item: ShoppingListItemEntity(id: UUID(), name: "test Item 1", quantity: 2, didPurchase: true, createdAt: Date()), toggleAction: { }, deleteAction: { })
}
