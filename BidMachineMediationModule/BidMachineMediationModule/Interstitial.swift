//
//  Interstitial.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation
import UIKit


@objc (BMMInterstitial) public
class Interstitial: NSObject {
    
    @objc public
    weak var delegate: InterstitialDelegate?
    
    private lazy var mediationController: MediationController = {
        let controller = MediationController()
        controller.delegate = self
        return controller
    }()
    
    private var adapter: MediationAdapter?
    
    public override init() {
        
    }
    
}

@objc public
extension Interstitial {
    
    @objc func loadAd() {
        guard mediationController.isAvailable else { return }
        mediationController.loadAd(.interstitial)
    }
    
    @objc func present(from viewController: UIViewController) {
        guard var adapter = self.adapter else {
            self.delegate.flatMap { $0.interstitialFailToPresentAd(self, with: MediationError.presentError("Adapter not found")) }
            return;
        }
        
        adapter.presentingDelegate = self
        adapter.present(viewController)
    }
    
    @objc var isReady: Bool {
        return adapter.flatMap { $0.ready } ?? false
    }
}

extension Interstitial: MediationControllerDelegate {
    
    func controllerDidLoad(_ controller: MediationController, _ adapter: MediationAdapter) {
        self.adapter = adapter
        self.delegate.flatMap { $0.interstitialDidLoadAd(self) }
    }
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error) {
        self.delegate.flatMap { $0.interstitialFailToLoadAd(self, with:error) }
    }
}

extension Interstitial: MediationAdapterPresentingDelegate {
    
    public func willPresentScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.interstitialWillPresentAd(self) }
    }
    
    public func didFailPresent(_ adapter: MediationAdapter, _ error: Error) {
        self.delegate.flatMap { $0.interstitialFailToPresentAd(self, with: error) }
    }
    
    public func didDismissScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.interstitialDidDismissAd(self) }
    }
    
    public func didTrackImpression(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.interstitialDidTrackImpression(self) }
    }
    
    public func didTrackInteraction(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.interstitialRecieveUserAction(self) }
    }
}
