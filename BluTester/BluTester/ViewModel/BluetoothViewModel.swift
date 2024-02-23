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
    
    func connect(device: CBPeripheral) {
        manager?.connect(device)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        print("centralManagerDidUpdateState \(central.state)")
        
        if central.state == .poweredOn {
            self.manager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil && !devices.contains(peripheral) {
            devices.append(peripheral)
            
            print("didDiscover \(peripheral.name ?? "(unknown device)")")
            print(advertisementData)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect to \(String(describing: peripheral.name))")
        
        manager?.stopScan()
        
        logger.log(level: .success, message: "didConnect to \(String(describing: peripheral.name)) canSendWriteWithoutResponse = \(peripheral.canSendWriteWithoutResponse)")
        
        self.connectedPeripheral = peripheral
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect \(error.debugDescription)")
        
        logger.log(level: .error, message: "didFailToConnect to \(String(describing: peripheral.name)) error: \(error.debugDescription)")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral \(String(describing: error?.localizedDescription))")
        
        logger.log(level: .warning, message: "didDisconnectPeripheral from \(String(describing: peripheral.name)) error: \(String(describing: error?.localizedDescription))")
        
        peripheral.delegate = nil
        self.connectedPeripheral = nil
    }
    
    
}

extension BluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices\n \(String(describing: peripheral.services))")
        
        discoverCharacteristics(peripheral: peripheral)
    }
    
    // Call after discovering services
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            print("service \(service.description)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        print("didDiscoverCharacteristicsFor \(service.description)")
        
        // Consider storing important characteristics internally for easy access and equivalency checks later.
        // From here, can read/write to characteristics or subscribe to notifications as desired.
        
        for characteristic in characteristics {
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
        
        print("didDiscoverDescriptorsFor \(characteristic.description) \(characteristic.uuid)")
     
        // Get user description descriptors
        for descriptor in descriptors {
            peripheral.readValue(for: descriptor)
        }
    }
     
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        switch descriptor.uuid.uuidString {
        case CBUUIDCharacteristicExtendedPropertiesString:
            guard let properties = descriptor.value as? NSNumber else {
                break
            }
            print("  Extended properties: \(properties)")
        case CBUUIDCharacteristicUserDescriptionString:
            guard let description = descriptor.value as? NSString else {
                break
            }
            print("  User description: \(description)")
        case CBUUIDClientCharacteristicConfigurationString:
            guard let clientConfig = descriptor.value as? NSNumber else {
                break
            }
            print("  Client configuration: \(clientConfig)")
        case CBUUIDServerCharacteristicConfigurationString:
            guard let serverConfig = descriptor.value as? NSNumber else {
                break
            }
            print("  Server configuration: \(serverConfig)")
        case CBUUIDCharacteristicFormatString:
            guard let format = descriptor.value as? NSData else {
                break
            }
            print("  Format: \(format)")
        case CBUUIDCharacteristicAggregateFormatString:
            print("  Aggregate Format: (is not documented)")
        default:
            break
        }
    }
}
