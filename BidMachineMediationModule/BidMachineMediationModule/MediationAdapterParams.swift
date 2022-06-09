//
//  MediationAdapterParams.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import UIKit

open class MediationAdapterParams: MediationAdapterParamsProtocol {
    
    public var size: MediationSize = .unowned
    
    public var price: Double = 0
    
    public weak var controller: UIViewController?
    
    public weak var container: UIView?
    
    public required init(_ params: MediationParams) {
        
    }
}
