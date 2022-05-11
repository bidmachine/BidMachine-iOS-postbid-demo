//
//  MediationAdapter.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation
import UIKit

struct MediationAdaptorsParams {
    let name: String
    let price: Double
    
    var pretty: String {
        return ("< \(name) : \(price) >")
    }
}

public protocol MediationAdapter  {
    
    var price: Double { get }
    
    var name: String { get }
    
    var ready: Bool { get }
    
    var loadingDelegate: MediationAdapterLoadingDelegate? { get set }
    
    var presentingDelegate: MediationAdapterPresentingDelegate? { get set }

    func load(_ price: Double)
    
    func present(_ controller: UIViewController)
}

public protocol MediationAdapterLoadingDelegate: AnyObject {
    
    func didLoad(_ adapter: MediationAdapter)
    
    func failLoad(_ adapter: MediationAdapter, _ error: Error)
}

public protocol MediationAdapterPresentingDelegate: AnyObject {
    
    func willPresentScreen(_ adapter: MediationAdapter)
    
    func didFailPresent(_ adapter: MediationAdapter, _ error: Error)
    
    func didDismissScreen(_ adapter: MediationAdapter)
    
    func didTrackImpression(_ adapter: MediationAdapter)
    
    func didTrackInteraction(_ adapter: MediationAdapter)
    
    func didTrackReward(_ adapter: MediationAdapter)
    
    func containerView() -> UIView?
}

public extension MediationAdapterPresentingDelegate {
    
    func didTrackReward(_ adapter: MediationAdapter) {
        
    }
    
    func containerView() -> UIView? {
        return nil
    }
    
    func rootViewController() -> UIViewController? {
        return nil
    }
}
