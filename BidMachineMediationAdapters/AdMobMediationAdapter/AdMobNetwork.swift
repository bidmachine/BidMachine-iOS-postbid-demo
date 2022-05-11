//
//  AdMobNetwork.swift
//  AdMobMediationAdapter
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import BidMachineMediationModule

class AdMobPostBidNetwork: MediationNetwork {
    
    struct LineItem {
        let price: Double
        let unitId: String
    }
    
    struct Constants {
        static let name = "AdMob"
    }
    
    var type: MediationType = .postbid
    
    func adapter(_ placement: MediationPlacement) -> MediationAdapter? {
        return placement.adapter()
    }
    
    required init() {
        
    }
}

extension MediationPlacement {
    func adapter() -> MediationAdapter? {
        switch self {
        case .banner: return AdMobBannerAdapter()
        case .interstitial: return AdMobInterstitialAdapter()
        case .rewarded: return AdMobRewardedAdapter()
        default: return nil
        }
    }
}

extension Array where Element == AdMobPostBidNetwork.LineItem {
    
    func lineItemWithPrice(_ price: Double) -> Element? {
        return self.sorted { $0.price < $1.price }.filter { $0.price > price }.first
    }
    
}
