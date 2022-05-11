//
//  ApplovinNetwork.swift
//  ApplovinMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import BidMachineMediationModule

class ApplovinPreBidNetwork: MediationNetwork {
    
    struct Constants {
        static let name = "Applovin_MAX"
        
        static func unitId(_ placement: MediationPlacement) -> String {
            switch placement {
            case .banner: return "YOUR_UNIT_ID"
            case .interstitial: return "YOUR_UNIT_ID"
            case .rewarded: return "YOUR_UNIT_ID"
            default: return "YOUR_UNIT_ID"
            }
        }
    }
    
    var type: MediationType = .prebid
    
    func adapter(_ placement: MediationPlacement) -> MediationAdapter? {
        return placement.adapter()
    }
    
    required init() {
        
    }
}

extension MediationPlacement {
    func adapter() -> MediationAdapter? {
        
        let unitId = ApplovinPreBidNetwork.Constants.unitId(self)
        
        switch self {
        case .banner: return ApplovinBannerAdapter(unitId)
        case .interstitial: return ApplovinInterstitialAdapter(unitId)
        case .rewarded: return ApplovinRewardedAdapter(unitId)
        default: return nil
        }
    }
}
