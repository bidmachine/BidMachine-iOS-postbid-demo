//
//  PreBidOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

class PreBidOperation: AsyncOperation {
    
    private let networkController: NetworkController
    
    init(_ placement: MediationPlacement){
        networkController = NetworkController(placement, NetworkRegistration.shared.networks(from: .prebid))
    }
    
    override func main() {
        Logging.log("----- Start prebid block")
        networkController.loadAd { [weak self] in
            Logging.log("------------ Loaded adapters: \(self.flatMap{ $0.networkController.adaptors().adaptorsParams.prettyParams } ?? [])")
            Logging.log("----- Complete prebid block")
            self.flatMap { $0.state = .finished }
        }
    }
}

extension PreBidOperation: BidOperation {
    
    func adaptors() -> [MediationAdapter] {
        return networkController.adaptors()
    }
}
