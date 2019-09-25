//
//  SetUpViewController.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/9/24.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class SetUpViewController:UIViewController{
    @IBOutlet weak var higherBound: UITextField!
    @IBOutlet weak var lowerBound: UITextField!
    
    @IBAction func quitKeyboard(_ sender: Any) {
        higherBound.resignFirstResponder()
        lowerBound.resignFirstResponder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? HeartRateMonitorResult{
            if let higherBound = higherBound.text{
                if let higherBoundRead = Int(higherBound){
                    destinationVC.higherBound = higherBoundRead
                }
            }
            if let lowerBound = lowerBound.text{
                if let lowerBoundRead = Int(lowerBound){
                    destinationVC.lowerBound = lowerBoundRead
                }
            }
        }
        
    }
}
