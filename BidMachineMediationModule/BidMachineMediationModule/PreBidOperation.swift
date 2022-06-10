//
//  PreBidOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

class PreBidOperation: AsyncOperation {
    
    private let wrapperController: MediationAdapterWrapperController
    
    private var isPriceFloor: Bool = false
    
    init(_ request: Request){
        if request.priceFloor > 0 {
            isPriceFloor = true
            wrapperController = MediationAdapterWrapperController([])
        } else {
            let wrappers: [MediationAdapterWrapper] = request.adapterParams.compactMap { MediationAdapterWrapper($0, request, .prebid ) }
            wrapperController = MediationAdapterWrapperController(wrappers)
        }
    }
    
    override func cancel() {
        if isExecuting {
            Logging.log("----- ❌❌ Canceled prebid block (TIMEOUT) ❌❌")
            Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
            Logging.log("----- Complete prebid block")
        }
        super.cancel()
    }
    
    override func main() {
        if isPriceFloor {
            self.state = .finished
            return
        }
        Logging.log("----- Start prebid block")
        wrapperController.load(self)
    }
}

extension PreBidOperation: MediationAdapterWrapperControllerDelegate {
    
    func controllerDidComplete(_ controller: MediationAdapterWrapperController) {
        guard isExecuting else { return }
        Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
        Logging.log("----- Complete prebid block")
        self.state = .finished
    }
}

extension PreBidOperation: BidOperation {
    
    func adaptorWrappers() -> [MediationAdapterWrapper] {
        return wrapperController.wrappers()
    }
}
