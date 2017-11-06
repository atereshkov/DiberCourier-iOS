//
//  LogManager.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import EXPLogger

class LogManager: NSObject {
    
    static let shared = LogManager()
    static let log = LogManager().logger
    
    let logger = EXPLogger.self
    
    // MARK: Init
    
    func initialize() {
        let console = ConsoleTarget()
        console.minLogLevel = .verbose
        logger.addTarget(console)
    }
    
}
