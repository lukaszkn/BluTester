//
//  BluetoothViewModel.swift
//  BluTester
//
//  Created by Lukasz on 22/02/2024.
//
// https://developer.apple.com/documentation/corebluetooth/transferring_data_between_bluetooth_low_energy_devices

import Foundation
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
    private var manager: CBCentralManager?
    @Published var devices: [CBPeripheral] = []
    var connectedPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        NSLog("centralManagerDidUpdateState \(central.state)")
        
        if central.state == .poweredOn {
            self.manager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        NSLog("didDiscover \(peripheral.name ?? "(unknown device)")")
        
        if peripheral.name != nil && !devices.contains(peripheral) {
            devices.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("didConnect to \(String(describing: peripheral.name))")
        self.connectedPeripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        NSLog("didFailToConnect \(error.debugDescription)")
    }
}
