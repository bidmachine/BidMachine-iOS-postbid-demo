//
//  AdMobBannerAdapter.swift
//  AdMobMediationAdapter
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import UIKit
import GoogleMobileAds
import BidMachineMediationModule

class AdMobBannerAdapter: NSObject, MediationAdapter {
    
    struct Constants {
        
        typealias LineItem = AdMobPostBidNetwork.LineItem
        
        /**
         * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
         * For each ad unit, you need to set up an eCPM floor and switch off auto refresh.
         */
        static let lineItems = [
            LineItem(price: 1.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 2.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 3.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 4.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 5.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 6.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 7.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 8.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 9.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
            LineItem(price: 10.0, unitId: "ca-app-pub-3940256099942544/2934735716")
        ]
    }
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = AdMobPostBidNetwork.Constants.name
    
    var ready: Bool {
        return isLoaded
    }
    
    var price: Double {
        return CPM
    }
    
    private var CPM: Double = 0
    
    private var isLoaded: Bool = false
    
    private lazy var banner: GADBannerView = {
        let banner = GADBannerView(adSize: GADAdSize(size: CGSize(width: 320, height: 50), flags: 0))
        banner.delegate = self
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    /**
     * Finds the first [LineItem] whose price is equal to or greater than the price floor and loads it.
     */
    func load(_ price: Double) {
        guard let lineItem = Constants.lineItems.lineItemWithPrice(price) else {
            self.loadingDelegate.flatMap { $0.failLoad(self, MediationError.noContent("Can't find AdMob line item"))}
            return
        }
        
        CPM = lineItem.price
        
        let request = GADRequest()
        banner.adUnitID = lineItem.unitId
        banner.rootViewController = UIApplication.shared.keyWindow?.rootViewController
        banner.load(request)
    }
    
    func present(_ controller: UIViewController) {
        guard let view = self.presentingDelegate?.containerView() else {
            self.presentingDelegate.flatMap { $0.didFailPresent(self, MediationError.presentError("AdMob banner"))}
            return;
        }
        
        view.addSubview(banner)
        banner.rootViewController = controller
        [banner.topAnchor.constraint(equalTo: view.topAnchor),
         banner.leftAnchor.constraint(equalTo: view.leftAnchor),
         banner.rightAnchor.constraint(equalTo: view.rightAnchor),
         banner.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { $0.isActive = true }
    }
}

extension AdMobBannerAdapter: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        isLoaded = true
        self.loadingDelegate.flatMap { $0.didLoad(self) }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
    }
}
