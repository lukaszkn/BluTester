//
//  ContentView.swift
//  BluTester
//
//  Created by Lukasz on 22/02/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = BluetoothViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.devices, id: \.self) { device in
                Text(device.name ?? "")
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("tap \(String(describing: device.name))")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
