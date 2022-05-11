//
//  ApplovinInterstitialAdapter.swift
//  ApplovinMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import UIKit
import AppLovinSDK
import BidMachineMediationModule

class ApplovinInterstitialAdapter: NSObject, MediationAdapter {
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = ApplovinPreBidNetwork.Constants.name
    
    var ready: Bool {
        return interstitial.isReady
    }
    
    var price: Double {
        return revenue * 1000
    }
    
    private var revenue: Double = 0
    
    private var unitId: String
    
    private lazy var interstitial: MAInterstitialAd = {
        let interstitial = MAInterstitialAd(adUnitIdentifier: unitId)
        interstitial.delegate = self
        return interstitial
    }()
    
    init(_ unitId: String) {
        self.unitId = unitId
    }
    
    func load(_ price: Double) {
        interstitial.load()
    }
    
    func present(_ controller: UIViewController) {
        interstitial.show()
    }
}

extension ApplovinInterstitialAdapter: MAAdDelegate {
    
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
}
