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
    
    var network: MediationNetworkProtocol
    
    var params: MediationParams
    
    private var state: State = .idle
    
    init?(_ pair: MediationPair) {
        let klass = NSClassFromString(pair.name) as? MediationNetworkProtocol.Type
        guard let klass = klass else {
            return nil
        }

        params = pair.params
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
    
    func didInitialized(_ network: MediationNetworkProtocol) {
        self.state = .ready
    }
    
    func didFailInitialized(_ network: MediationNetworkProtocol, _ error: Error) {
        self.state = .idle
    }
}