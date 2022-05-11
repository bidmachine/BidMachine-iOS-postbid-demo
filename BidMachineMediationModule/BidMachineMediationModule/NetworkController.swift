//
//  NetworkController.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

typealias NetworkControllerCompletionBlock = () -> Void

class NetworkController {

    private let placement: MediationPlacement
    
    private var concurentAdapters: [MediationAdapter] = []
    
    private var loadedAdapters: [MediationAdapter] = []
    
    private var concurentGroup: DispatchGroup?
    
    init(_ _placement: MediationPlacement, _ networks: [MediationNetwork]) {
        placement = _placement
        concurentAdapters = networks.compactMap { $0.adapter(placement) }
    }
}

extension NetworkController {
    
    func adaptors() -> [MediationAdapter] {
        return loadedAdapters
    }
}

extension NetworkController {
    
    func loadAd(_ price: Double = 0, _ _completion: @escaping NetworkControllerCompletionBlock) {
        guard concurentAdapters.count > 0 else {
            _completion()
            return;
        }
        
        Logging.log("------- Mediated adapters: \(concurentAdapters.adaptorsParams.prettyParams)")
        Logging.log("------- Mediated price: \(price)")
        
        let group = DispatchGroup()
        concurentGroup = group
        
        concurentAdapters.forEach {
            group.enter()
    
            var network = $0
            network.loadingDelegate = self
            network.load(price)
        }
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            self.flatMap { $0.concurentAdapters = [] }
            _completion()
        }
    }
}

extension NetworkController: MediationAdapterLoadingDelegate {
    
    func didLoad(_ adapter: MediationAdapter) {
        loadedAdapters.append(adapter)
        concurentGroup?.leave()
    }
    
    func failLoad(_ adapter: MediationAdapter, _ error: Error) {
        concurentGroup?.leave()
    }
}


