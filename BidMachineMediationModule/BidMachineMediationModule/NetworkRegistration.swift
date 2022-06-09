//
//  NetworkRegistration.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation


@objc (BMMNetworkRegistration) public
class NetworkRegistration: NSObject {
    
    @objc public static
    let shared = NetworkRegistration()
    
    private var networks: [RegisteredNetwork] = []
    
    private override init() {
        super.init()
    }
    
}

@objc public
extension NetworkRegistration {
    
    @objc
    func registerNetwork(_ className: String, _ params: MediationParams) {
        let newNetwork = RegisteredNetwork(.pair(className, params))
        let isDuplicate = networks.filter { $0.network.networkName == newNetwork?.network.networkName }.count != 0
        guard let newNetwork = newNetwork, !isDuplicate else { return }
    
        networks.append(newNetwork)
        newNetwork.initializeIfNeeded()
    }
}

extension NetworkRegistration {
    
    func network(_ name: String) -> MediationNetwork? {
        return networks.filter { $0.network.networkName == name && $0.initializeIfNeeded() }.first?.network
    }
}
