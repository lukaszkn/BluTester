//
//  BluTesterApp.swift
//  BluTester
//
//  Created by Lukasz on 22/02/2024.
//

import SwiftUI
import SwiftUILogger

let logger = SwiftUILogger(name: "Log")

@main
struct BluTesterApp: App {
    var body: some Scene {
        WindowGroup {
            DevicesView()
        }
    }
}
