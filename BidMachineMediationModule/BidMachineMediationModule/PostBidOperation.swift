//
//  PostBidOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

class PostBidOperation: AsyncOperation {
    
    private let wrapperController: MediationAdapterWrapperController
    
    private let requestPrice: Double
    
    init(_ request: Request){
        let wrappers: [MediationAdapterWrapper] = request.adapterParams.compactMap { MediationAdapterWrapper($0, request, .postbid ) }
        wrapperController = MediationAdapterWrapperController(wrappers)
        requestPrice = request.priceFloor
    }
    
    override func cancel() {
        if isExecuting {
            Logging.log("----- ❌❌ Canceled postbid block (TIMEOUT) ❌❌")
            Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
            Logging.log("----- Complete postbid block")
        }
        super.cancel()
    }
    
    override func main() {
        Logging.log("----- Start postbid block")
        let wrappers:[MediationAdapterWrapper] = self.dependencies.compactMap { $0 as? BidOperation }.flatMap { $0.adaptorWrappers() }
        let price: Double = wrappers.maxPriceWrapper().flatMap { $0.price } ?? requestPrice
        
        wrapperController.load(self, price)
    }
}

extension PostBidOperation: MediationAdapterWrapperControllerDelegate {
    
    func controllerDidComplete(_ controller: MediationAdapterWrapperController) {
        guard isExecuting else { return }
        Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
        Logging.log("----- Complete postbid block")
        self.state = .finished
    }
}

extension PostBidOperation: BidOperation {
    
    func adaptorWrappers() -> [MediationAdapterWrapper] {
        return wrapperController.wrappers()
    }
}
