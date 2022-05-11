//
//  Logging.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import Foundation

class Logging {
    
    static let shared = Logging()
    
    private init() {
        
    }
}

extension Logging {
    
    static func log(_ fmt: String) {
        self.shared.log(fmt)
    }
    
    private func log(_ fmt : String) {
        print("[BidMachineMediation] \(fmt.capitalized)")
    }
}
