//
//  AdRequestProtocol.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation

public typealias RequestBuilder = (AdRequest) -> Void

public typealias MediationParams = [String: Any]

@objc (BMMMediationPlacement) public
enum MediationPlacement: Int {
    case unowned
    case banner
    case interstitial
    case rewarded
}

@objc (BMMType) public
enum MediationType: Int {
    case prebid
    case postbid
}

@objc (BMMSize) public
enum MediationSize: Int {
    case unowned = 0
    case banner = 50
    case mrec = 250
    case leaderboard = 90
}

@objc (BMMAdRequest) public
protocol AdRequest: AnyObject {
    
    @discardableResult func appendAdSize(_ size: MediationSize) -> AdRequest
    
    @discardableResult func appendPriceFloor(_ price: Double) -> AdRequest
    
    @discardableResult func appendTimeout(_ timeout: Double) -> AdRequest
    
    @discardableResult func appendAdUnit(_ name: String, _ params: MediationParams) -> AdRequest
    
}

