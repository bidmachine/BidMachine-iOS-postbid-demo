//
//  Rewarded.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation
import UIKit


@objc (BMMRewarded) public
class Rewarded: NSObject {
    
    @objc public
    weak var delegate: RewardedDelegate?
    
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
extension Rewarded {
    
    @objc func loadAd() {
        guard mediationController.isAvailable else { return }
        mediationController.loadAd(.rewarded)
    }
    
    @objc func present(from viewController: UIViewController) {
        guard var adapter = self.adapter else {
            self.delegate.flatMap { $0.rewardedFailToPresentAd(self, with: MediationError.presentError("Adapter not found")) }
            return;
        }
        
        adapter.presentingDelegate = self
        adapter.present(viewController)
    }
    
    @objc var isReady: Bool {
        return adapter.flatMap { $0.ready } ?? false
    }
}

extension Rewarded: MediationControllerDelegate {
    
    func controllerDidLoad(_ controller: MediationController, _ adapter: MediationAdapter) {
        self.adapter = adapter
        self.delegate.flatMap { $0.rewardedDidLoadAd(self) }
    }
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error) {
        self.delegate.flatMap { $0.rewardedFailToLoadAd(self, with:error) }
    }
}

extension Rewarded: MediationAdapterPresentingDelegate {
    
    public func willPresentScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.rewardedWillPresentAd(self) }
    }
    
    public func didFailPresent(_ adapter: MediationAdapter, _ error: Error) {
        self.delegate.flatMap { $0.rewardedFailToPresentAd(self, with:error) }
    }
    
    public func didDismissScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.rewardedDidDismissAd(self) }
    }
    
    public func didTrackImpression(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.rewardedDidTrackImpression(self) }
    }
    
    public func didTrackInteraction(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.rewardedRecieveUserAction(self) }
    }
    
    public func didTrackReward(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.rewardedDidTrackReward(self) }
    }
}

