//
//  HeartRateView.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/9/17.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

class HeartRateView: UIView {
    var heartRateValue = [Int]()
    let lowerHeartRateBound = 80
    let higherHeartRateBound = 110
    var newCGPoint = CGPoint(x: 100, y: 100)
    let red = UIColor.red
    let blue = UIColor.blue
    let green = UIColor.green
    
    override func draw(_ rect: CGRect) {
        //Draw upper and lower bounds

        //set upper bound line
        let heartRateUpperBoundPath = UIBezierPath()
        heartRateUpperBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRatePositionConverter(heartRateReading: higherHeartRateBound)))
//        print(heartRatePositionConverter(heartRateReading: higherHeartRateBound))
        heartRateUpperBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRatePositionConverter(heartRateReading: higherHeartRateBound)))
        red.setStroke()
        heartRateUpperBoundPath.stroke()
        //set lower bound line
        let heartRateLowerBoundPath = UIBezierPath()
        heartRateLowerBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRatePositionConverter(heartRateReading: lowerHeartRateBound)))
        heartRateLowerBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRatePositionConverter(heartRateReading: lowerHeartRateBound)))
        blue.setStroke()
        heartRateLowerBoundPath.stroke()
        //set heart rate
        heartRateDraw()
        //TODO: change color when in different zone, set initial setting
    }
    
    private func heartRateDraw(){
        let heartRateDraw = UIBezierPath()
        heartRateDraw.move(to: CGPoint(x: CGFloat(1.0), y: bounds.height/2))
        var xTemp = CGFloat(1.0)
        let xIncrease = bounds.width/CGFloat(heartRateValue.count)*2/3
        for heartRate in heartRateValue{
            newCGPoint = CGPoint(x: xTemp, y: heartRatePositionConverter(heartRateReading: heartRate))
            heartRateDraw.addLine(to: newCGPoint)
            xTemp += xIncrease
            
            
        }
        switch heartRateValue.last ?? 0{
        case 0..<lowerHeartRateBound:
            blue.setStroke()
        case lowerHeartRateBound..<higherHeartRateBound:
            green.setStroke()
        default:
            red.setStroke()
        }
        heartRateDraw.stroke()
        
    }
    
    private func heartRatePositionConverter(heartRateReading:Int) -> CGFloat {
        let maxHeartRate = 255
        let yIncrease = bounds.height/CGFloat(maxHeartRate)
        let lowerHeartRateBoundPosition = bounds.height
        let heartRatePosition = lowerHeartRateBoundPosition - CGFloat(heartRateReading)*yIncrease
        return heartRatePosition
    }

}
