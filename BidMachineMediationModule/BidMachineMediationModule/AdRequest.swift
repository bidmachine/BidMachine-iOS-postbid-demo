//
//  AdRequest.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation
import UIKit

enum MediationPair {
    
    case pair(String, MediationParams)
    
    var name: String {
        switch self {
        case .pair(let name,_): return name
        }
    }
    
    var params: MediationParams {
        switch self {
        case .pair(_, let params): return params
        }
    }
}

class Request {
    
    private(set) var size: MediationSize = .unowned
    
    private(set) var priceFloor: Double = 0
    
    private(set) var timeout: Double = 20
    
    private(set) var prebidTimeout: Double = 20
    
    private(set) var postbidTimeout: Double = 20
    
    private(set) var adapterParams: [MediationPair] = []
    
    private(set) var placement: MediationPlacement = .unowned
    
    private(set) weak var controller: UIViewController?
    
    private(set) weak var container: UIView?
    
}

extension Request {
    
    @discardableResult func appendPlacement(_ placement: MediationPlacement) -> Request {
        self.placement = placement
        return self
    }
    
    @discardableResult func appendController(_ controller: UIViewController?) -> Request {
        self.controller = controller
        return self
    }
    
    @discardableResult func appendContainer(_ container: UIView?) -> Request {
        self.container = container
        return self
    }
}

extension Request : AdRequest {
    
    @discardableResult func appendTimeout(_ timeout: Double, by type: MediationType) -> AdRequest {
        switch type {
        case .prebid: timeout > 0 ? self.prebidTimeout = timeout : nil
        case .postbid: timeout > 0 ? self.postbidTimeout = timeout : nil
        }
        return self
    }
    
    @discardableResult func appendPriceFloor(_ price: Double) -> AdRequest {
        self.priceFloor = price
        return self
    }
    
    @discardableResult func appendTimeout(_ timeout: Double) -> AdRequest {
        if timeout > 0 {
            self.timeout = timeout
        }
        return self
    }
    
    @discardableResult func appendAdUnit(_ name: String, _ params: MediationParams) -> AdRequest {
        self.adapterParams.append(.pair(name, params))
        return self
    }
    
    @discardableResult func appendAdSize(_ size: MediationSize) -> AdRequest {
        self.size = size
        return self
    }
}
