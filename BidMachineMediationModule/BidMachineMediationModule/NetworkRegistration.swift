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
    
    private var networks: [MediationNetwork] = []
    
    private override init() {
        super.init()
    }
    
}

@objc public
extension NetworkRegistration {
    
    @objc
    func registerNetworks(_ networks: [String]) {
        self.networks = networks
            .compactMap { NSClassFromString($0) as? MediationNetwork.Type }
            .compactMap { $0.init() }
    }
    
}

extension NetworkRegistration {
    
    func networks(from type: MediationType) -> [MediationNetwork] {
        return networks.filter { $0.type == type }
    }
    
}
