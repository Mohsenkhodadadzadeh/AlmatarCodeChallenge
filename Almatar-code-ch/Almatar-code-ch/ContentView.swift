//
//  ContentView.swift
//  Almatar-code-ch
//
//  Created by mohsen on 7/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        Text("Test")
    }

   
}


