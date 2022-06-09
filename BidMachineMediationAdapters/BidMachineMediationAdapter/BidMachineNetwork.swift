//
//  BidMachineNetwork.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import BidMachine
import BidMachineMediationModule

class BidMachineNework: MediationNetwork {
    
    public typealias T = BidMachineNeworkParams
    
    required init() {
        super.init()
        name = "BidMachine"
    }
    
    override func adapter(_ type: MediationType, _ placement: MediationPlacement) -> MediationAdapter.Type? {
        return nil
    }
    
    override func initializeNetwork<P>(_ params: P) where P : MediationNetworkParamsProtocol {
        guard let params: T = params as? T, let sourceId = params.sourceId else {
            delegate.flatMap { $0.didFailInitialized(self, MediationError.loadingError("Required params id null")) }
            return
        }
        
        BDMSdk.shared().startSession(withSellerID: sourceId) {
            
        }
    }
}

//class BidMachinePreBidNetwork: BidMachineNework {
//    override var type: MediationType {
//        get { return .prebid }
//        set {}
//    }
//}
//
//class BidMachinePostBidNetwork: BidMachineNework {
//    override var type: MediationType {
//        get { return .postbid }
//        set {}
//    }
//}
//
//extension MediationPlacement {
//    func adapter() -> MediationAdapter? {
//        switch self {
//        case .banner: return BidMachineBannerAdapter()
//        case .interstitial: return BidMachineInterstitialAdapter()
//        case .rewarded: return BidMachineRewardedAdapter()
//        default: return nil
//        }
//    }
//}
