//
//  BluetoothListTableViewController.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/10/9.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothListTableViewController:UITableViewController,CBCentralManagerDelegate,CBPeripheralDelegate{
    
    
    var manager:CBCentralManager!
    var scanResult = [CBPeripheral]()
    var heartRatePeripheral:CBPeripheral!
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    var test = ["a","b"]
    
    override func viewDidLoad() {
        manager = CBCentralManager(delegate: self, queue: nil, options: nil)
        
    }
    
    //Get bluetooth device list
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        manager.scanForPeripherals(withServices: [heartRateServiceCBUUID], options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        scanResult.append(peripheral)
        tableView.reloadData()
    }
    
    //Show the bluetooth device on list
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothDevice", for: indexPath) as? BluetoothListTableViewCell else {fatalError("Cell doesn't exist")}
        cell.bluetoothDeviceName.text = scanResult[indexPath.row].name
        cell.status.isOn = true
        return cell
    }
    
}
