//
//  MediationNetwork.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import UIKit

public enum MediationPlacement {
    case banner
    case interstitial
    case rewarded
}

public enum MediationType {
    case prebid
    case postbid
    case unowned
}

public protocol MediationNetwork {
    
    init()
    
    var type: MediationType { get }
    
    func adapter(_ placement: MediationPlacement) -> MediationAdapter?
}

