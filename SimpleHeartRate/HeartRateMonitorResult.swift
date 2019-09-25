//
//  FirstViewController.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/8/11.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit
import CoreBluetooth


class HeartRateMonitorResult: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var scanResult = [CBPeripheral]()
    var heartRatePeripheral:CBPeripheral!
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    var heartRateReading = 0
    var heartRateLabel:UILabel!
    var time:TimeInterval!
    var timeInRange:TimeInterval!
    var higherBound:Int!
    var lowerBound:Int!
    
    @IBOutlet weak var heartRatePlotView: HeartRateView!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var timeInHeartRateRange: UILabel!
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set bluetooth manager
        manager = CBCentralManager(delegate: self, queue: nil, options: nil)
        //set heartRatePlotView's movable uilabel fro heart rate
        heartRateLabel = UILabel(frame: CGRect(x: heartRatePlotView.bounds.width*0.7, y: heartRatePlotView.heartRatePositionConverter(heartRateReading: (heartRatePlotView.higherHeartRateBound + heartRatePlotView.lowerHeartRateBound)/2), width: 100, height: 100))
        heartRateLabel.text = "None"
        heartRateLabel.font = UIFont.systemFont(ofSize: CGFloat(35))
        heartRateLabel.textColor = .blue
        heartRatePlotView.addSubview(heartRateLabel)
        heartRatePlotView.higherHeartRateBound = higherBound
        heartRatePlotView.lowerHeartRateBound = lowerBound
        

        
        
        

    }
    
    
     //MARK:Actions
    @IBAction func start(_ sender: Any) {
        time = TimeInterval()
        timeInRange = TimeInterval()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.updateTimer()
            
        })
    }
    
    
    //MARK:delegates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        NSLog("centralManagerDidUpdate")
        manager.scanForPeripherals(withServices: [heartRateServiceCBUUID], options: nil)
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
        heartRateReading = heartRate(from: characteristic)
        heartRatePlotView.heartRateValue.append(heartRateReading)
//        if heartRateReading > 0{
//            heartRateLabel.frame.origin.x = heartRatePlotView.newCGPoint.x
//            heartRateLabel.frame.origin.y = heartRatePlotView.newCGPoint.y
//            heartRateLabel.text = String(heartRateReading)
//            heartRatePlotView.setNeedsDisplay()
//        }
        heartRateLabel.text = String(heartRateReading)
        heartRatePlotView.setNeedsDisplay()
        switch heartRateReading{
        case 0..<heartRatePlotView.lowerHeartRateBound:
            heartRateLabel.textColor = .blue
        case heartRatePlotView.lowerHeartRateBound..<heartRatePlotView.higherHeartRateBound:
            heartRateLabel.textColor = .green
        default:
            heartRateLabel.textColor = .red
        }

        
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
    
    private func updateTimer(){
        //set normal timer
        self.time += 1
        self.totalTime.text = self.time.stringDisplay()
        self.timeInHeartRateRange.text = self.timeInRange.stringDisplay()
        //set heart rate timer
        if self.heartRateReading < self.heartRatePlotView.higherHeartRateBound && self.heartRateReading > self.heartRatePlotView.lowerHeartRateBound{
            self.timeInRange += 1
        }
        self.timeInHeartRateRange.text = self.timeInRange.stringDisplay()
    }
    



}


//MARK:Extentions
extension TimeInterval{
    func stringDisplay() -> String{
        let time = Int(self)
        let hour = time/3600
        let minute = (time/60)%60
        let second = time%60
        return String(format:"%0.2d:%0.2d:%0.2d", hour,minute,second)
    }
}

