//
//  SortShoppingItemsUseCase.swift
//  ShoppingListFeature
//
//  Created by mohsen on 7/4/25.
//
import Foundation

public enum ShoppingItemSortOrder: CaseIterable, Identifiable {
    public var id: Self { self }

    case creationDateAscending
    case creationDateDescending
    case modificationDateAscending
    case modificationDateDescending

    public var title: String {
        switch self {
        case .creationDateAscending: return "Creation Date (Asc)"
        case .creationDateDescending: return "Creation Date (Desc)"
        case .modificationDateAscending: return "Modification Date (Asc)"
        case .modificationDateDescending: return "Modification Date (Desc)"
        }
    }
}

public class SortShoppingItemsUseCase {
    public init() {} // This use case doesn't need a repository

    public func execute(items: [ShoppingListItemEntity], order: ShoppingItemSortOrder) -> [ShoppingListItemEntity] {
        print("UseCase: Sorting items by \(order.title)")
        var sortedItems = items
        switch order {
        case .creationDateAscending:
            sortedItems.sort { $0.createdAt < $1.createdAt }
        case .creationDateDescending:
            sortedItems.sort { $0.createdAt > $1.createdAt }
        case .modificationDateAscending:
            sortedItems.sort { $0.updatedAt ?? Date() < $1.updatedAt ?? Date() }
        case .modificationDateDescending:
            sortedItems.sort { $0.updatedAt ?? Date() > $1.updatedAt ?? Date() }
        }
        return sortedItems
    }
}
