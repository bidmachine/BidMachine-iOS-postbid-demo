//
//  ApplovinBannerAdapter.swift
//  ApplovinMediationAdapter
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import UIKit
import AppLovinSDK
import BidMachineMediationModule

class ApplovinBannerAdapter: NSObject, MediationAdapter {
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = ApplovinPreBidNetwork.Constants.name
    
    var ready: Bool {
        return isLoaded
    }
    
    var price: Double {
        return revenue * 1000
    }
    
    private var revenue: Double = 0
    
    private var isLoaded: Bool = false
    
    private var unitId: String
    
    private lazy var banner: MAAdView = {
        let banner = MAAdView(adUnitIdentifier: unitId, adFormat: MAAdFormat.banner)
        banner.frame = CGRect(origin: .zero, size: MAAdFormat.banner.size)
        banner.delegate = self
        return banner
    }()
    
    init(_ unitId: String) {
        self.unitId = unitId
    }
    
    func load(_ price: Double) {
        banner.loadAd()
    }
    
    func present(_ controller: UIViewController) {
        guard let view = self.presentingDelegate?.containerView() else {
            self.presentingDelegate.flatMap { $0.didFailPresent(self, MediationError.presentError("Applovin banner"))}
            return;
        }
        
        view.addSubview(banner)
        [banner.topAnchor.constraint(equalTo: view.topAnchor),
         banner.leftAnchor.constraint(equalTo: view.leftAnchor),
         banner.rightAnchor.constraint(equalTo: view.rightAnchor),
         banner.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { $0.isActive = true }
    }
}

extension ApplovinBannerAdapter: MAAdViewAdDelegate {
    
    func didLoad(_ ad: MAAd) {
        isLoaded = true
        revenue = ad.revenue
        
        banner.stopAutoRefresh()
        self.loadingDelegate.flatMap { $0.didLoad(self) }
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        self.loadingDelegate.flatMap { $0.failLoad(self, MediationError.noContent(error.description)) }
    }
    
    func didDisplay(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        self.presentingDelegate.flatMap { $0.didFailPresent(self, MediationError.presentError(error.description)) }
    }
    
    func didClick(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
    }
    
    func didExpand(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func didCollapse(_ ad: MAAd) {
        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func didHide(_ ad: MAAd) {
        
    }
    
}

