//
//  MediationNetwork.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import UIKit

open class MediationNetwork: MediationNetworkProtocol {
    
    open var name: String = "unowned"

    public typealias T = MediationNetworkParams
    
    public typealias U = MediationAdapter
    
    public weak var delegate: MediationNetworkDelegate?
    
    public var networkName: String {
        return name
    }
    
    public required init() { }
    
    open func initializeNetwork<P>(_ params: P) where P : MediationNetworkParamsProtocol {
        self.delegate.flatMap { $0.didFailInitialized(self, MediationError.noContent("Should be override in ad network"))}
    }
    
    open func adapter(_ type: MediationType, _ placement: MediationPlacement) -> U.Type? {
        return MediationAdapter.self
    }
}
