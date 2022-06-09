//
//  RegisteredNetwork.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation

class RegisteredNetwork {
    
    private enum State {
        case idle
        case pending
        case ready
    }
    
    let params: MediationNetworkParams
    
    let network: MediationNetwork
    
    private var state: State = .idle
    
    init?(_ pair: MediationPair) {
        let klass = NSClassFromString(pair.name) as? MediationNetwork.Type
        guard let klass = klass else {
            return nil
        }
        params = klass.T.init(pair.params)
        network = klass.init()
    }
}

extension RegisteredNetwork {
    
    @discardableResult func initializeIfNeeded() -> Bool {
        network.delegate = self
        
        switch self.state {
        case .idle: network.initializeNetwork(params); return false
        case .pending: return false
        case .ready: return true
        }
    }
}

extension RegisteredNetwork: MediationNetworkDelegate {
    
    func didInitialized(_ network: MediationNetwork) {
        self.state = .ready
    }
    
    func didFailInitialized(_ network: MediationNetwork, _ error: Error) {
        self.state = .idle
    }
}
