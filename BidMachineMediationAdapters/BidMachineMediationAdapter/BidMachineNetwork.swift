//
//  BidMachineNetwork.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import BidMachineMediationModule

class BidMachineNework: MediationNetwork {
    
    struct Constants {
        static let name = "BidMachine"
    }
    
    var type: MediationType = .unowned
    
    func adapter(_ placement: MediationPlacement) -> MediationAdapter? {
        return placement.adapter()
    }
    
    required init() {
        
    }
}

class BidMachinePreBidNetwork: BidMachineNework {
    override var type: MediationType {
        get { return .prebid }
        set {}
    }
}

class BidMachinePostBidNetwork: BidMachineNework {
    override var type: MediationType {
        get { return .postbid }
        set {}
    }
}

extension MediationPlacement {
    func adapter() -> MediationAdapter? {
        switch self {
        case .banner: return BidMachineBannerAdapter()
        case .interstitial: return BidMachineInterstitialAdapter()
        case .rewarded: return BidMachineRewardedAdapter()
        default: return nil
        }
    }
}
