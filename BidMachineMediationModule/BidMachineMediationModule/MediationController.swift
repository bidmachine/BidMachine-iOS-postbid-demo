//
//  MediationController.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

protocol MediationControllerDelegate: AnyObject {
    
    func controllerDidLoad(_ controller: MediationController, _ wrapper: MediationAdapterWrapper)
    
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
    
    func loadRequest(_ request: Request) {
        
        if request.controller == nil {
            self.delegate.flatMap { $0.controllerFailWithError(self, MediationError.loadingError("Controller is required parameters"))}
            return
        }
        
        if request.adapterParams.count == 0 {
            request
                .appendAdUnit(NetworDefines.bidmachine.name, MediationParams())
        }
        
        let preBidOperation = PreBidOperation(request)
        let postBidOperation = PostBidOperation(request)
        let completionOperation = CompletionOperation { wrapper in
            DispatchQueue.main.async { [weak self] in
                self.flatMap { $0.complete(with: wrapper) }
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
    
    func complete(with wrapper: MediationAdapterWrapper?) {
        isAvailable = true
        guard let wrapper = wrapper else {
            self.delegate.flatMap { $0.controllerFailWithError(self, MediationError.noContent("Adapter not loaded")) }
            return;
        }
        self.delegate.flatMap { $0.controllerDidLoad(self, wrapper) }
    }
    
}
