//
//  TaskListApp.swift
//  TaskList
//
//  Created by Nicolas Santiago on 05-02-24.
//

import SwiftUI
import Firebase

@main
struct TaskListApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    // MARK: Initialize firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
