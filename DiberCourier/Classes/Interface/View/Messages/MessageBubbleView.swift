//
//  MessageBubbleView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/22/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class MessageBubbleView: UIView {
    
    let myColor = UIColor.init(red: 154.0 / 255.0, green: 211.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    let senderColor = UIColor.init(red: 201.0 / 255.0, green: 224.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    
    var currentUserIsSender = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        // draw main body
        bezierPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 10.0))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        // draw the tail
        if currentUserIsSender {
            bezierPath.move(to: CGPoint(x: rect.maxX - 25.0, y: rect.maxY - 10.0))
            bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.0, y: rect.maxY - 10.0))
            myColor.setFill()
        } else {
            bezierPath.move(to: CGPoint(x: rect.minX + 25.0, y: rect.maxY - 10.0))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY))
            bezierPath.addLine(to: CGPoint(x: rect.minX + 10.0, y: rect.maxY - 10.0))
            senderColor.setFill()
        }
        bezierPath.fill()
        bezierPath.close()
    }
    
}
