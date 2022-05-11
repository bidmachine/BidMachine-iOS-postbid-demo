//
//  ApplovinRewardedAdapter.swift
//  ApplovinMediationAdapter
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import UIKit
import AppLovinSDK
import BidMachineMediationModule

class ApplovinRewardedAdapter: NSObject, MediationAdapter {
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = ApplovinPreBidNetwork.Constants.name
    
    var ready: Bool {
        return rewarded.isReady
    }
    
    var price: Double {
        return revenue * 1000
    }
    
    private var revenue: Double = 0
    
    private var unitId: String
    
    private lazy var rewarded: MARewardedAd = {
        let rewarded = MARewardedAd.shared(withAdUnitIdentifier: unitId)
        rewarded.delegate = self
        return rewarded
    }()
    
    init(_ unitId: String) {
        self.unitId = unitId
    }
    
    func load(_ price: Double) {
        rewarded.load()
    }
    
    func present(_ controller: UIViewController) {
        rewarded.show()
    }
}

extension ApplovinRewardedAdapter: MARewardedAdDelegate {

    func didLoad(_ ad: MAAd) {
        revenue = ad.revenue
        self.loadingDelegate.flatMap { $0.didLoad(self) }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        self.loadingDelegate.flatMap { $0.failLoad(self, MediationError.noContent(error.description)) }
    }
    
    func didDisplay(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        self.presentingDelegate.flatMap { $0.didFailPresent(self, MediationError.presentError(error.description)) }
    }
    
    func didHide(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func didClick(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
    }
    
    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        self.presentingDelegate.flatMap { $0.didTrackReward(self) }
    }
    
    func didStartRewardedVideo(for ad: MAAd) {
        
    }
    
    func didCompleteRewardedVideo(for ad: MAAd) {
        
    }
}
