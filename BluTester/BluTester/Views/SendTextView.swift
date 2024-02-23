//
//  SendTextView.swift
//  BluTester
//
//  Created by Lukasz on 23/02/2024.
//

import SwiftUI
import CoreBluetooth

struct SendTextView: View {
    
    var selectedDevice: CBPeripheral?
    @State private var textToSend: String = ""
    
    var body: some View {
        ZStack {
            Color(Color(.systemGroupedBackground))
            VStack {
                Form {
                    TextField("Text to display on LCD", text: $textToSend)
                    
                    Button("Send to \(selectedDevice?.name ?? "(connect to device first)")") {
                        
                    }
                    .disabled(selectedDevice == nil)
                }
                .frame(height: 150)
                
                List {
                    Section(header: Text("Tap on sample text")) {
                        Text("Hello world!")
                        Text("Greetings master")
                    }
                }
                
                Spacer()
            }
        }
        
    }
}

#Preview {
    SendTextView()
}
