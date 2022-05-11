//
//  PostBidOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

class PostBidOperation: AsyncOperation {
    
    private let networkController: NetworkController
    
    init(_ placement: MediationPlacement){
        networkController = NetworkController(placement, NetworkRegistration.shared.networks(from: .postbid))
    }
    
    override func main() {
        Logging.log("----- Start postbid block")
        let adaptors:[MediationAdapter] = self.dependencies.compactMap { $0 as? BidOperation }.flatMap { $0.adaptors() }
        let price: Double = adaptors.maxPriceAdaptor().flatMap { $0.price } ?? 0
        
        networkController.loadAd(price) { [weak self] in
            Logging.log("------------ Loaded adapters: \(self.flatMap{ $0.networkController.adaptors().adaptorsParams.prettyParams } ?? [])")
            Logging.log("----- Complete postbid block")
            self.flatMap { $0.state = .finished }
        }
    }
}

extension PostBidOperation: BidOperation {
    
    func adaptors() -> [MediationAdapter] {
        return networkController.adaptors()
    }
}
