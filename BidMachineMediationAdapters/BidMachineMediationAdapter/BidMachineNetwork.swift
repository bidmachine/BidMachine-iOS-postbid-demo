//
//  BidMachineNetwork.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import BidMachineMediationModule

class BidMachineNework: MediationNetwork {
    
    public typealias T = BidMachineNeworkParams
    
    required init() {
        self.name = "BidMachine"
    }
    
    override func adapter(_ type: MediationType, _ placement: MediationPlacement) -> MediationAdapter.Type? {
        return nil
    }
    
    override func initializeNetwork(_ params: MediationNetworkParams) {
        
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
