//
//  HeartRateView.swift
//  SimpleHeartRate
//
//  Created by Lezardvaleth on 2019/9/17.
//  Copyright © 2019 Lezardvaleth. All rights reserved.
//

import UIKit

@IBDesignable class HeartRateView: UIView {
    var heartRateValue = [CGFloat]()
    override func draw(_ rect: CGRect) {
        //Draw upper and lower bounds
        let heartRateUpperBoundHeight = bounds.height/10
        let heartRateLowerBoundHeight = bounds.height*9/10
        //set upper bound line
        let heartRateUpperBoundPath = UIBezierPath()
        heartRateUpperBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRateUpperBoundHeight))
        heartRateUpperBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRateUpperBoundHeight))
        let red = UIColor.red
        red.setStroke()
        heartRateUpperBoundPath.stroke()
        //set lower bound line
        let heartRateLowerBoundPath = UIBezierPath()
        heartRateLowerBoundPath.move(to: CGPoint(x: CGFloat(0.0), y: heartRateLowerBoundHeight))
        heartRateLowerBoundPath.addLine(to: CGPoint(x: bounds.width, y: heartRateLowerBoundHeight))
        let green = UIColor.green
        green.setStroke()
        heartRateLowerBoundPath.stroke()
        //set heart rate
        let heartRateStartPoint = CGPoint(x: CGFloat(0.0), y: bounds.height/2)
        let heartRatePath = UIBezierPath()
        heartRatePath.move(to: heartRateStartPoint)
        
        var yTemp = 0
        for _ in 1...100{
            yTemp = Int.random(in: -100...100)
            heartRateValue.append(CGFloat(yTemp))
        }
        heartRateDraw()
    }
    
    private func heartRateDraw(){
        let heartRateDraw = UIBezierPath()
        heartRateDraw.move(to: CGPoint(x: CGFloat(1.0), y: bounds.height/2))
        var xTemp = CGFloat(1.0)
        for heartRate in heartRateValue{
            heartRateDraw.addLine(to: CGPoint(x: xTemp, y: bounds.height/2 + heartRate))
            xTemp += CGFloat(5.0)
        }
        heartRateDraw.stroke()
    }

}
