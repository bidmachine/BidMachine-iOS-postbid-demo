//
//  MediationAdapterWrapperController.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

protocol MediationAdapterWrapperControllerDelegate: AnyObject {
    
    func controllerDidComplete(_ controller: MediationAdapterWrapperController)
}

class MediationAdapterWrapperController {
    
    private weak var delegate: MediationAdapterWrapperControllerDelegate?
    
    private var concurentWrappers: [MediationAdapterWrapper] = []
    
    private var loadedWrappers: [MediationAdapterWrapper] = []
    
    init(_ wrappers:  [MediationAdapterWrapper]) {
        concurentWrappers = wrappers
    }
}

private extension MediationAdapterWrapperController {
    
    func notifyMediationCompleteIfNeeded() {
        if (self.concurentWrappers.count == 0) {
            self.delegate.flatMap { $0.controllerDidComplete(self) }
        }
    }
    
}

extension MediationAdapterWrapperController {
    
    func wrappers() -> [MediationAdapterWrapper] {
        return loadedWrappers
    }
    
    func load(_ delegate: MediationAdapterWrapperControllerDelegate, _ price: Double = 0) {
        Logging.log("------- Mediated adapters: \(concurentWrappers)")
        Logging.log("------- Mediated price: \(price)")
        
        self.delegate = delegate
        self.notifyMediationCompleteIfNeeded()
        concurentWrappers.forEach { $0.load(price, self) }
    }
}

extension MediationAdapterWrapperController: MediationAdapterWrapperLoadingDelegate {
    
    func didLoad(_ wrapper: MediationAdapterWrapper) {
        self.concurentWrappers.removeAll { $0 == wrapper }
        self.loadedWrappers.append(wrapper)
        self.notifyMediationCompleteIfNeeded()
    }
    
    func failLoad(_ wrapper: MediationAdapterWrapper, _ error: Error) {
        self.concurentWrappers.removeAll { $0 == wrapper }
        self.notifyMediationCompleteIfNeeded()
    }
}

