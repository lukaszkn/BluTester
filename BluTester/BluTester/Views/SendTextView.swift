//
//  SendTextView.swift
//  BluTester
//
//  Created by Lukasz on 23/02/2024.
//

import SwiftUI
import CoreBluetooth

struct SendTextView: View {
    
    @EnvironmentObject private var viewModel: BluetoothViewModel
    @State private var textToSend: String = ""
    
    var sampleTexts = [
        "Hello world!",
        "Greetings",
        "Hello .intent",
        "Ala ma kota"
    ]
    
    var body: some View {
        ZStack {
            Color(Color(.systemGroupedBackground))
            VStack {
                Form {
                    TextField("Text to display on LCD", text: $textToSend)
                    
                    Button("Send to \(viewModel.connectedPeripheral?.name ?? "(connect to device first)")") {
                        viewModel.sendLcdText(text: textToSend)
                        viewModel.sendLcdText(text: textToSend)
                    }
                    .disabled(viewModel.connectedPeripheral == nil)
                }
                .frame(height: 150)
                
                List {
                    Section(header: Text("Tap on sample text")) {
                        ForEach(sampleTexts, id: \.self) { text in
                            Text(text).onTapGesture {
                                textToSend = text
                            }
                        }
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
