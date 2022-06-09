//
//  MediationAdapterProtocol.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import UIKit

public protocol MediationAdapterProtocol: AnyObject  {
    
    associatedtype T: MediationAdapterParamsProtocol
    
    var adapterPrice: Double { get }
    
    var adapterReady: Bool { get }
    
    var adapterParams: T? { get }
    
    var loadingDelegate: MediationAdapterLoadingDelegate? { get set }
    
    var displayDelegate: MediationAdapterDisplayDelegate? { get set }
    
    init(_ params: T)

    func load()
    
    func present()
}

public protocol MediationAdapterLoadingDelegate: AnyObject {
    
    func didLoad(_ adapter: MediationAdapter)
    
    func failLoad(_ adapter: MediationAdapter, _ error: Error)
}

public protocol MediationAdapterDisplayDelegate: AnyObject {
    
    func willPresentScreen(_ adapter: MediationAdapter)
    
    func didFailPresent(_ adapter: MediationAdapter, _ error: Error)
    
    func didDismissScreen(_ adapter: MediationAdapter)
    
    func didTrackImpression(_ adapter: MediationAdapter)
    
    func didTrackInteraction(_ adapter: MediationAdapter)
    
    func didTrackReward(_ adapter: MediationAdapter)
    
    func didTrackExpired(_ adapter: MediationAdapter)
}
