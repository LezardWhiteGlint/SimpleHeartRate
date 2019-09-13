//
//  FirstViewController.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/8/11.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreBluetooth

class FirstViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var scanResult = [CBPeripheral]()
    var heartRatePeripheral:CBPeripheral!
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    
    
    @IBOutlet weak var heartRateDisplay: UITextField!
    
    
    //MARK:Actions
    @IBOutlet weak var test: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil, options: nil)
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func scan(_ sender: Any) {
        NSLog("start scanning")
        manager.scanForPeripherals(withServices: [heartRateServiceCBUUID], options: nil)
        
    }
    
    //MARK:delegates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("centralManagerDidUpdate")
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        Try connect to one divice
        if peripheral.name == "Heart Rate Sensor"{
            heartRatePeripheral = peripheral
            heartRatePeripheral.delegate = self
            manager.connect(heartRatePeripheral, options: nil)
            NSLog("scanning stopped")
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        NSLog("connection successful "+(peripheral.name ?? "unkown device"))
        manager.stopScan()
        heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        NSLog("didDIscoverServices")
        print(heartRatePeripheral.services!)
        heartRatePeripheral.discoverCharacteristics([heartRateMeasurementCharacteristicCBUUID], for: heartRatePeripheral.services![0])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        for characteristic in characteristics{
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor characteristic")
        heartRateDisplay.text = String(heartRate(from: characteristic))
    }
    
    
    //MARK:Helper Functions
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }

    

        
        
    

}

