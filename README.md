# Modular Shopping List Feature

This repository contains a modular "Shopping List" feature developed in Swift, designed for integration into a larger super-application. The project adheres to **Clean Architecture** principles, implements an **offline-first** strategy, and leverages modern iOS development technologies like **SwiftUI, Combine, and Swift Concurrency**.

## Overview

The "Shopping List" module provides comprehensive functionality for managing shopping items, ensuring a seamless user experience even when offline, with robust background synchronization. Its architecture emphasizes separation of concerns, testability, and maintainability.

## Features

Users can perform the following actions within the Shopping List module:

* **Add, Edit, Delete Items:** Full CRUD (Create, Read, Update, Delete) operations for shopping items, including:
    * Name (required)
    * Quantity (required)
    * Note (optional)
* **Mark as "Purchased":** Toggle the status of an item to mark it as purchased. Bought items are hidden by default but can be toggled with a filter.
* **Filtering:** Toggle visibility of "Purchased" vs. "not Purchased" items. // Not Implemented Yet
* **Searching:** Search items by name or note. // Not Implemeted Yet
* **Sorting:** Sort the list by creation or modification date (ascending/descending). // Not Implemeted Yet
* **Offline-First:** The feature is designed to work fully offline, providing immediate responsiveness.

## Architecture

The project employs a **Clean Architecture** approach, combined with **MVVM (Model-View-ViewModel)** for the presentation layer and the **Coordinator Pattern** for navigation. This layered design ensures a clear separation of concerns, high testability, and maintainability.

* **Presentation Layer:**
    * **Views (SwiftUI):** `CoordinatorView` (the root navigation view), `ShoppingListView`, `ShoppingListItemRow`, `AddItemSheet`, `SortOptionsSheet`. These views are responsible for rendering the UI and forwarding user interactions to the ViewModel or Coordinator.
    * **ViewModels (`ShoppingListViewModel`):** `ObservableObject` classes that transform data for the views, expose UI state (`isLoading`, `errorMessage`), and handle presentation-specific logic (e.g., applying filters, search, and sort). They interact with Use Cases.
    * **Coordinator (`MainCoordinator`):** Manages the navigation flow within the module. It decouples navigation logic from individual views and view models, making the flow explicit and centralized.

* **Domain Layer:**
    * **Entities (`ShoppingItem`):** Pure Swift data structures representing the core business objects. They are `Identifiable`, `Codable`, and `Equatable`.
    * **Use Cases (Interactors):** Encapsulate specific business rules and operations (e.g., `GetShoppingItemsUseCase`, `AddShoppingItemUseCase`, `FilterShoppingItemsUseCase`). They interact with the `ShoppingItemRepositoryProtocol` and contain no UI or persistence logic.
    * **Interfaces (`ShoppingItemRepositoryProtocol`):** Protocols defining the contracts for data access, abstracting data source details from the Domain layer.

* **Data Layer:**
    * **Repository (`ShoppingItemRepository`):** Implements `ShoppingItemRepositoryProtocol`. This is the single source of truth for `ShoppingItem` data, orchestrating interactions between local and remote data sources and the sync manager. It implements the offline-first strategy.
    * **Data Sources (`LocalShoppingItemDataSourceProtocol`, `RemoteShoppingItemDataSourceProtocol`):** Protocols defining low-level data access for local storage and remote API respectively.
    * **Implementations (Currently Mocked):**
        * `InMemoryLocalShoppingItemDataSource` (for local persistence): An in-memory store that uses Combine's `CurrentValueSubject` to provide reactive updates.
        * `MockRemoteShoppingItemDataSource` (for remote API): Simulates network calls with delays.
    * **Sync Manager (`SyncManagerProtocol`, `MockSyncManager`):** Manages background synchronization, conflict resolution, and retry logic. Currently, `MockSyncManager` is used, which simulates sync operations without actual network interaction.

## Technical Details

* **Language:** Swift
* **UI Framework:** SwiftUI // UIKit will be implemented
* **Concurrency:**
    * **Swift Concurrency (`async/await`):** Used for imperative, one-off operations, particularly within the Data Layer (e.g., saving to local storage, making remote API calls).
    * **Combine Framework:** Extensively used for reactive data observation and stream processing. The `ShoppingItemRepository` provides `AnyPublisher` streams, allowing `ViewModels` to reactively subscribe to data changes.
* **Modularity:** The feature is packaged as a **Swift Package** (`ShoppingListModule`) for easy integration into a super-app and to enforce clear module boundaries.
* **Dependency Injection:** Implemented using the **Factory Pattern** and **Manual Injection**. A `ShoppingListModuleFactory` centralizes the creation and wiring of all dependencies (data sources, repository, use cases, view models), which are then passed explicitly via initializers.
* **Persistence:** Currently uses in-memory mocks. The architecture is designed for future integration with real persistence technologies like SwiftData, Core Data, or Realm for local storage, and a JSON-based REST API for remote synchronization.

## Getting Started

To build and run the project:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Mohsenkhodadadzadeh/AlmatarCodeChallenge.git](https://github.com/Mohsenkhodadadzadeh/AlmatarCodeChallenge.git)
    cd AlmatarCodeChallenge
    ```
2.  **Switch to the `shopping-list` branch:**
    ```bash
    git checkout shopping-list
    ```
3.  **Open the project in Xcode:**
    ```bash
    open AlmatarCodeChallenge.xcodeproj
    ```
4.  **Select the `SuperApp` scheme** from the scheme selector in Xcode.
5.  **Run the project** on a simulator or device (Cmd + R).

You should see the `CoordinatorView` which manages the navigation for the Shopping List feature.

## Testing

The project includes a comprehensive testing strategy:

* **Unit Tests:** Implemented for ViewModels, Use Cases, and the Repository layer. These tests use mock dependencies to ensure business logic and data flow are correct in isolation. // just 20% test cases have been written

## Project Artifacts

* `README.md`: This document.
* `DESIGN_DOC.md`: Detailed architectural decisions and rejected alternatives.
* Build and run instructions are provided above.

## Future Enhancements

* Implement actual local persistence (SwiftData/Core Data/Realm) to replace `InMemoryLocalShoppingItemDataSource`.
* Develop a robust remote API client and integrate with a real JSON-based REST API to replace `MockRemoteShoppingItemDataSource`.
* Improve UI/UX with more polished designs, animations, and accessibility features.
