//
//  MediationNetworkProtocol.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation

public protocol MediationNetworkProtocol: AnyObject {
    
    associatedtype T: MediationNetworkParamsProtocol
    associatedtype U: MediationAdapterProtocol

    init()
    
    var networkName: String { get }
    
    var delegate: MediationNetworkDelegate? { get set }
    
    func adapter(_ type: MediationType, _ placement: MediationPlacement) -> U.Type?
    
    func initializeNetwork<P: MediationNetworkParamsProtocol>(_ params: P)
}


public protocol MediationNetworkDelegate: AnyObject {
    
    func didInitialized(_ network: MediationNetwork)
    
    func didFailInitialized(_ network: MediationNetwork, _ error: Error)
}

