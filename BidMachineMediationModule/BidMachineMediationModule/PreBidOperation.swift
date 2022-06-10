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
    
    private var timer: Timer?
    
    private let timeout: Double
    
    private var mediationTime: Double = 0
    
    init(_ request: Request){
        timeout = request.prebidTimeout
        
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
            let time = Date().timeIntervalSince1970 - self.mediationTime
            Logging.log("----- ❌❌ Canceled prebid block (TIMEOUT) ❌❌")
            Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
            Logging.log("----- Complete prebid block - \(Double(round(1000 * time))) ms")
        }
        self.invalidateTimer()
        super.cancel()
    }
    
    override func main() {
        if isPriceFloor {
            self.state = .finished
            return
        }
        
        self.mediationTime = Date().timeIntervalSince1970
        Logging.log("----- Start prebid block")
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeout, repeats: false, block: { [weak self] _ in
            self?.cancel()
        })
        wrapperController.load(self)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension PreBidOperation: MediationAdapterWrapperControllerDelegate {
    
    func controllerDidComplete(_ controller: MediationAdapterWrapperController) {
        guard isExecuting else { return }
        self.invalidateTimer()
        
        let time = Date().timeIntervalSince1970 - self.mediationTime
        Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
        Logging.log("----- Complete prebid block - \(Double(round(1000 * time))) ms")
        self.state = .finished
    }
}

extension PreBidOperation: BidOperation {
    
    func adaptorWrappers() -> [MediationAdapterWrapper] {
        return wrapperController.wrappers()
    }
}
