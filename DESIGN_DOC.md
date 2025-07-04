# Shopping List Feature Design Document

## 1. Introduction

This document outlines the architectural design and key decisions for the "Shopping List" feature, a modular component intended for integration into a larger super-application. The primary goal is to deliver a robust, maintainable, testable, and scalable solution that adheres to modern iOS development best practices and an offline-first paradigm.

## 2. Architectural Decisions

### 2.1 Overall Architecture: Clean Architecture with MVVM

The project adopts a **Clean Architecture** (also known as Onion Architecture) pattern, with **MVVM (Model-View-ViewModel)** applied specifically to the Presentation Layer.

* **Justification:**
    * **Decoupling:** Strict layer separation minimizes dependencies between components, making them independent and reusable.
    * **Testability:** Each layer can be tested in isolation using mocks and stubs, leading to high test coverage and confidence.
    * **Maintainability:** Changes in one layer (e.g., switching database technology) have minimal impact on others.
    * **Scalability:** Facilitates parallel development by multiple teams in a super-app context.
    * **Domain Focus:** The core business logic (Domain Layer) remains independent of UI frameworks, databases, or external services.

* **Layer Breakdown:**
    * **Presentation Layer:** (Views, ViewModels, Coordinator)
        * **Views (SwiftUI):** `CoordinatorView` (the module's root), `ShoppingListView`, `ShoppingListItemRow`, `AddItemSheet`, `SortOptionsSheet`. These are "dumb" views responsible for rendering UI and forwarding user input. They observe `ViewModel` properties and invoke `ViewModel` actions.
        * **ViewModels (`ShoppingListViewModel`):** `ObservableObject` classes that transform data from Use Cases for display, manage UI-specific state (`isLoading`, `errorMessage`), and handle presentation-related logic such as applying filters, search, and sort. They interact with Use Cases via initializer injection.
        * **Coordinator (`MainCoordinator`):** Manages the navigation flow within the module using `NavigationStack`. It decouples navigation logic from individual views and view models, making the application's flow explicit, centralized, and testable.
    * **Domain Layer:** (Entities, Use Cases, Interfaces)
        * **Entities (`ShoppingItem`):** Pure Swift structs defining the application's core data models. They are `Codable`, `Identifiable`, and `Equatable`.
        * **Use Cases (Interactors):** Encapsulate specific business rules and operations (e.g., `GetShoppingItemsUseCase`, `AddShoppingItemUseCase`, `FilterShoppingItemsUseCase`, `SearchShoppingItemsUseCase`, `SortShoppingItemsUseCase`, `ToggleBoughtStatusUseCase`, `UpdateShoppingItemUseCase`, `DeleteShoppingItemUseCase`). They orchestrate data flow by interacting with the `ShoppingItemRepositoryProtocol` and contain no UI or persistence logic.
        * **Interfaces (`ShoppingItemRepositoryProtocol`):** Protocols that define the contracts for data access, abstracting the underlying data storage details from the Use Cases. The `observeShoppingItems()` method returns a Combine `AnyPublisher` for reactive data streams.
    * **Data Layer:** (Repositories, Data Sources, Sync Manager)
        * **Repository (`ShoppingItemRepository`):** Implements `ShoppingItemRepositoryProtocol`. This is the single, authoritative source of truth for `ShoppingItem` data. It orchestrates interactions with both local and remote data sources and the `SyncManager` to fulfill data requests from the Domain layer. It implements the offline-first strategy by prioritizing local data for reads and queuing writes for background synchronization.
        * **Data Sources (`LocalShoppingItemDataSourceProtocol`, `RemoteShoppingItemDataSourceProtocol`):** Protocols defining low-level operations for specific storage technologies (e.g., in-memory mock, SwiftData, REST API). The `LocalShoppingItemDataSourceProtocol`'s `observeAll()` method returns a Combine `AnyPublisher`.
        * **Implementations (Currently Mocked):** `InMemoryLocalShoppingItemDataSource` (for local persistence) and `MockRemoteShoppingItemDataSource` (for remote API) are used for initial development.
        * **Sync Manager (`SyncManagerProtocol`, `MockSyncManager`):** A dedicated component responsible for managing background synchronization, conflict resolution, and retry logic between local and remote data sources. Currently, `MockSyncManager` is used.

### 2.2 Dependency Injection: Factory Pattern + Manual Injection

* **Strategy:** Dependencies are created and managed by a dedicated `ShoppingListModuleFactory` class. All dependencies are explicitly passed to consuming classes via **initializer injection**.
* **Justification:**
    * **Clarity:** The dependencies of any class are immediately visible in its `init()` method, improving code readability and understanding.
    * **Testability:** Facilitates easy mocking. For unit testing a `ViewModel`, mock `UseCases` can be injected. For testing a `UseCase`, a mock `Repository` can be provided.
    * **Control:** Provides full control over dependency lifecycle and graph construction without relying on external frameworks.
    * **No Third-Party Overhead:** Avoids adding external libraries, keeping the project lightweight and demonstrating a fundamental understanding of DI.
    * **Composition Root:** The `ShoppingListModuleFactory` acts as the module's composition root, centralizing the wiring of all components.

### 2.3 Navigation: Coordinator Pattern

* **Strategy:** The `MainCoordinator` class, an `ObservableObject`, manages the `NavigationStack`'s `path` property and defines navigation paths using a `Page` enum. The `CoordinatorView` is the module's public root view, instantiating and utilizing the `MainCoordinator`.
* **Justification:**
    * **Decoupling:** Views and ViewModels remain unaware of navigation logic, focusing solely on their UI and presentation responsibilities.
    * **Centralized Flow:** All navigation logic is consolidated in the `MainCoordinator`, making it easier to visualize, manage, and modify application flows.
    * **Reusability:** Individual views can be reused in different navigation contexts without modification.
    * **Testability:** Navigation flows can be unit-tested independently of the UI.

### 2.4 Data Flow & Offline-First Strategy

* **Single Repository Abstraction:** The `ShoppingItemRepository` serves as the single point of contact for the Domain layer, abstracting whether data comes from local or remote sources.
* **Offline-First Implementation:**
    * **Reads (`fetchShoppingItems()`):** The repository immediately returns data from the `LocalShoppingItemDataSource`. Concurrently, it triggers the `SyncManager` to perform a background synchronization with the `RemoteShoppingItemDataSource`.
    * **Writes (`add`, `update`, `delete`):** Changes are immediately applied to the `LocalShoppingItemDataSource` for instant UI responsiveness. These changes are then queued with the `SyncManager` for eventual synchronization with the remote.
    * **Reactive Updates:** The `ShoppingItemRepository` exposes a Combine `AnyPublisher` (`observeShoppingItems()`) that directly reflects changes in the `LocalShoppingItemDataSource`. This ensures the UI automatically updates when local data changes, whether by user action or by the `SyncManager` reconciling remote changes.

### 2.5 Modularity: Swift Package

* **Strategy:** The entire Shopping List feature is packaged as a **Swift Package** (`ShoppingListModule`).
* **Justification:**
    * **Clear Boundaries:** Enforces strict modularity, making it explicit what is part of the feature and what is external.
    * **Reusability:** The module can be easily integrated into any other Swift project (like a super-app) via Swift Package Manager.
    * **Independent Development:** Allows for independent development, testing, and versioning of the feature.

## 3. Rejected Alternatives

### 3.1 Alternative 1: Using a Third-Party Dependency Injection Framework (e.g., Resolver, Swinject)

* **Reasoning for Rejection:** While third-party DI containers offer powerful features like automatic resolution, lifecycle management, and compile-time safety (in some cases), for this specific code challenge, demonstrating a manual DI strategy using the Factory Pattern provides a clearer insight into the fundamental understanding of dependency management. It also avoids introducing an external dependency, keeping the project more self-contained and reducing potential learning curves for evaluators. For a larger, long-term production application, a robust third-party DI framework might be considered.

### 3.2 Alternative 2: Separate Repositories for Local and Remote Data in Use Cases

* **Reasoning for Rejection:** An alternative approach might involve defining `LocalShoppingItemRepository` and `RemoteShoppingItemRepository` protocols and injecting both into Use Cases. This violates the core principle of the Repository Pattern in Clean Architecture, which states that the Domain layer should be completely agnostic to the data's origin. If Use Cases directly interact with `Local` and `Remote` repositories, they become coupled to the data's source, making the Domain layer less "clean" and harder to test. The chosen approach centralizes the data source decision and offline-first logic within a single `ShoppingItemRepository`, maintaining a cleaner abstraction for the Domain layer.

### 3.3 Alternative 3: Navigation Logic Directly in Views/ViewModels (No Coordinator)

* **Reasoning for Rejection:** For simpler applications, navigation directly from views or view models might seem convenient. However, in a modular feature intended for a super-app, this leads to tightly coupled views, reduced reusability, and makes complex navigation flows (e.g., deep linking, authentication flows, multi-step forms) difficult to manage, test, and modify. The Coordinator pattern centralizes navigation, promoting cleaner views and more maintainable navigation graphs.

## 4. Technical Implementation Highlights

* **Swift Concurrency:** Utilized for imperative asynchronous operations (e.g., network requests, database writes) within the Data Layer.
* **Combine Framework:** Extensively used for reactive data observation, particularly for propagating changes from the `LocalShoppingItemDataSource` through the `ShoppingItemRepository` and `GetShoppingItemsUseCase` to the `ShoppingListViewModel`. This enables the SwiftUI UI to react automatically to data updates.
* **Mock Implementations:** `InMemoryLocalShoppingItemDataSource`, `MockRemoteShoppingItemDataSource`, and `MockSyncManager` are currently used. These provide a stable environment for initial development and unit testing, allowing the core logic to be built before integrating real persistence and networking. These will be replaced in later phases.

## 5. Testing Strategy

* **Unit Tests:** Comprehensive unit tests are written for the `ShoppingListViewModel`, all `UseCases`, and the `ShoppingItemRepository`. These tests employ mock dependencies to isolate the component under test, ensuring its logic is correct and robust.
* **UI Tests:** Planned using XCTest or Swift Testing macros to verify end-to-end user flows and UI interactions.

## 6. Git Strategy

The project follows an incremental commit strategy, with each commit representing a meaningful development step, ensuring a clear and traceable development history.
