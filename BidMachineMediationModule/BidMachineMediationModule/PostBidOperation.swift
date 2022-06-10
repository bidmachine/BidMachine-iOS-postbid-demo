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
    
    private var timer: Timer?
    
    private let timeout: Double
    
    private var mediationTime: Double = 0
    
    private var mediationType: MediationType
    
    init(_ request: Request){
        timeout = request.postbidTimeout
        mediationType = request.mediationType
        
        if mediationType == .prebid {
            wrapperController = MediationAdapterWrapperController([])
        } else {
            let wrappers: [MediationAdapterWrapper] = request.adapterParams.compactMap { MediationAdapterWrapper($0, request, .postbid ) }
            wrapperController = MediationAdapterWrapperController(wrappers)
        }
        
        requestPrice = request.priceFloor
    }
    
    override func cancel() {
        if isExecuting {
            let time = Date().timeIntervalSince1970 - self.mediationTime
            Logging.log("----- ❌❌ Canceled postbid block (TIMEOUT) ❌❌")
            Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
            Logging.log("----- Complete postbid block - \(Double(round(1000 * time))) ms")
        }
        self.invalidateTimer()
        super.cancel()
    }
    
    override func main() {
        if mediationType == .prebid {
            self.state = .finished
            return
        }
        
        Logging.log("----- Start postbid block")
        let wrappers:[MediationAdapterWrapper] = self.dependencies.compactMap { $0 as? BidOperation }.flatMap { $0.adaptorWrappers() }
        var price: Double = wrappers.maxPriceWrapper().flatMap { $0.price } ?? 0
        price = price > requestPrice ? price : requestPrice
        
        
        self.mediationTime = Date().timeIntervalSince1970
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeout, repeats: false, block: { [weak self] _ in
            self?.cancel()
        })
        
        wrapperController.load(self, price)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension PostBidOperation: MediationAdapterWrapperControllerDelegate {
    
    func controllerDidComplete(_ controller: MediationAdapterWrapperController) {
        guard isExecuting else { return }
        self.invalidateTimer()
        
        let time = Date().timeIntervalSince1970 - self.mediationTime
        Logging.log("------------ Loaded adapters: \(self.adaptorWrappers())")
        Logging.log("----- Complete postbid block - \(Double(round(1000 * time))) ms")
        self.state = .finished
    }
}

extension PostBidOperation: BidOperation {
    
    func adaptorWrappers() -> [MediationAdapterWrapper] {
        return wrapperController.wrappers()
    }
}
