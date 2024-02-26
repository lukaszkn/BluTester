//
//  ContentView.swift
//  BluTester
//
//  Created by Lukasz on 22/02/2024.
//

import SwiftUI
import SwiftUILogger

struct DevicesView: View {
    @StateObject private var viewModel = BluetoothViewModel()
    
    init() {
        logger.log(level: .info, message: "init")
    }
    
    var body: some View {
        TabView {
            NavigationView {
                List(viewModel.devices, id: \.self) { device in
                    Text(device.name ?? "(unknown device)")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("tap \(String(describing: device.name))")
                            viewModel.connect(device: device)
                        }
                }
                .navigationTitle("Bluetooth devices")
            }
            .tabItem {
                Label("Devices", systemImage: "list.dash")
            }
            
            SendTextView()
                .tabItem {
                    Label("Send", systemImage: "square.and.pencil")
                }
            
            LoggerView(logger: logger)
                .tabItem {
                    Label("Log", systemImage: "ladybug")
                }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    DevicesView()
}
