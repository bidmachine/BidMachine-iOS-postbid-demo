//
//  MediationAdapter.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation
import UIKit

open class MediationAdapter: MediationAdapterProtocol {
    
    public typealias T = MediationAdapterParams
    
    open var price: Double = 0
    
    open var ready: Bool = false
    
    fileprivate var params: T
    
    fileprivate weak var _loadingDelegate: MediationAdapterLoadingDelegate?
    
    fileprivate weak var _displayDelegate: MediationAdapterDisplayDelegate?
    
    // Public
    
    public var adapterPrice: Double {
        
        return self.price
    }

    public var adapterReady: Bool  {
        
        return self.ready
    }
    
    public var adapterParams: MediationAdapterParams? {
        
        return self.params
    }

    public var loadingDelegate: MediationAdapterLoadingDelegate? {
        
        get { return self._loadingDelegate }
        set { self._loadingDelegate = newValue }
    }

    public var displayDelegate: MediationAdapterDisplayDelegate? {
        
        get { return self._displayDelegate }
        set { self._displayDelegate = newValue }
    }

    public func load () {
        
    }

    public func present() {
        
    }
    
    public required init(_ params: MediationAdapterParams) {
        self.params = params
    }
}
 
