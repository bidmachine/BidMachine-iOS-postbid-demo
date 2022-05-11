//
//  AdMobRewardedAdapter.swift
//  AdMobMediationAdapter
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import UIKit
import GoogleMobileAds
import BidMachineMediationModule

class AdMobRewardedAdapter: NSObject, MediationAdapter {
    
    struct Constants {
        
        typealias LineItem = AdMobPostBidNetwork.LineItem
        
        /**
         * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
         * For each ad unit, you need to set up an eCPM floor
         */
        static let lineItems = [
            LineItem(price: 1.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 2.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 3.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 4.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 5.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 6.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 7.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 8.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 9.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
            LineItem(price: 10.0, unitId: "ca-app-pub-3940256099942544/1712485313")
        ]
    }
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = AdMobPostBidNetwork.Constants.name
    
    var ready: Bool {
        return rewarded != nil
    }
    
    var price: Double {
        return CPM
    }
    
    private var CPM: Double = 0
    
    private var rewarded: GADRewardedAd?
    
    /**
     * Finds the first [LineItem] whose price is equal to or greater than the price floor and loads it.
     */
    func load(_ price: Double) {
        guard let lineItem = Constants.lineItems.lineItemWithPrice(price) else {
            self.loadingDelegate.flatMap { $0.failLoad(self, MediationError.noContent("Can't find AdMob line item"))}
            return
        }
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:  lineItem.unitId, request: request) { [weak self] rewarded, error in
            guard let rewarded = rewarded, let self = self, error == nil else  {
                self.flatMap { $0.loadingDelegate?.failLoad($0, MediationError.noContent(error.flatMap { $0.localizedDescription } ?? ""))}
                return
            }
            
            rewarded.fullScreenContentDelegate = self
        
            self.CPM = lineItem.price
            self.rewarded = rewarded
            self.loadingDelegate.flatMap { $0.didLoad(self) }
        }
    }
    
    func present(_ controller: UIViewController) {
        guard let rewarded = rewarded else { return }
        rewarded.present(fromRootViewController: controller) { [weak self] in
            self.flatMap { $0.presentingDelegate?.didTrackReward($0) }
        }
    }
}

extension AdMobRewardedAdapter: GADFullScreenContentDelegate {
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.presentingDelegate.flatMap { $0.didFailPresent(self, error) }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
    }
}
