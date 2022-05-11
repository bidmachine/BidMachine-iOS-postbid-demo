//
//  MediationController.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

protocol MediationControllerDelegate: AnyObject {
    
    func controllerDidLoad(_ controller: MediationController, _ adapter: MediationAdapter)
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error)
    
}

class MediationController {
    
    weak var delegate: MediationControllerDelegate?
    
    private(set) var isAvailable: Bool = true
    
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "com.bidmachine.mediation.module.queue"
        return queue
    }()
    
    func loadAd(_ placement: MediationPlacement) {
        
        let preBidOperation = PreBidOperation(placement)
        let postBidOperation = PostBidOperation(placement)
        let completionOperation = CompletionOperation { adapter in
            DispatchQueue.main.async { [weak self] in
                self.flatMap { $0.complete(with: adapter) }
            }
        }
        
        postBidOperation.addDependency(preBidOperation)
        completionOperation.addDependency(preBidOperation)
        completionOperation.addDependency(postBidOperation)
        
        isAvailable = false
        queue.addOperations([preBidOperation, postBidOperation, completionOperation], waitUntilFinished: false)
    }
}

private extension MediationController {
    
    func complete(with adapter: MediationAdapter?) {
        isAvailable = true
        guard let adapter = adapter else {
            self.delegate.flatMap { $0.controllerFailWithError(self, MediationError.noContent("Adapter not loaded")) }
            return;
        }
        self.delegate.flatMap { $0.controllerDidLoad(self, adapter) }
    }
    
}
