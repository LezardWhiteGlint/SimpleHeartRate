//
//  HeartRateView.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/9/17.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

@IBDesignable class HeartRateView: UIView {
    var heartRateValue = [Int]()
    let lowerHeartRateBound = 50
    let higherHeartRateBound = 200
    
    override func draw(_ rect: CGRect) {
        //Draw upper and lower bounds

        //set upper bound line
        let heartRateUpperBoundPath = UIBezierPath()
        heartRateUpperBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRatePositionConverter(heartRateReading: higherHeartRateBound)))
        heartRateUpperBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRatePositionConverter(heartRateReading: higherHeartRateBound)))
        let red = UIColor.red
        red.setStroke()
        heartRateUpperBoundPath.stroke()
        //set lower bound line
        let heartRateLowerBoundPath = UIBezierPath()
        heartRateLowerBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRatePositionConverter(heartRateReading: lowerHeartRateBound)))
        heartRateLowerBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRatePositionConverter(heartRateReading: lowerHeartRateBound)))
        let green = UIColor.green
        green.setStroke()
        heartRateLowerBoundPath.stroke()
        //set heart rate
        let heartRateStartPoint = CGPoint(x: CGFloat(0.0), y: bounds.height/2)
        let heartRatePath = UIBezierPath()
        heartRatePath.move(to: heartRateStartPoint)
        heartRateDraw()
    }
    
    private func heartRateDraw(){
        let heartRateDraw = UIBezierPath()
        heartRateDraw.move(to: CGPoint(x: CGFloat(1.0), y: bounds.height/2))
        var xTemp = CGFloat(1.0)
        let xIncrease = bounds.width/CGFloat(heartRateValue.count)
        for heartRate in heartRateValue{
            let newCGPoint = CGPoint(x: xTemp, y: heartRatePositionConverter(heartRateReading: heartRate))
            heartRateDraw.addLine(to: newCGPoint)
            xTemp += xIncrease
        }
        heartRateDraw.stroke()
    }
    
    private func heartRatePositionConverter(heartRateReading:Int) -> CGFloat {
        let highAndLowDifference = higherHeartRateBound - lowerHeartRateBound
        let yIncrease = bounds.height/CGFloat(highAndLowDifference)
        let lowerHeartRateBoundPosition = bounds.height
        let heartRatePosition = lowerHeartRateBoundPosition - CGFloat(heartRateReading)*yIncrease
        return heartRatePosition
    }

}
