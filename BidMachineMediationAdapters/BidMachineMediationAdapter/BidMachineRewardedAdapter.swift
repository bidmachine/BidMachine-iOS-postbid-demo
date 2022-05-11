//
//  BidMachineRewardedAdapter.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import UIKit
import BidMachine
import BidMachineMediationModule

class BidMachineRewardedAdapter: NSObject, MediationAdapter {
    
    weak var loadingDelegate: MediationAdapterLoadingDelegate?
    
    weak var presentingDelegate: MediationAdapterPresentingDelegate?
    
    var name: String = BidMachineNework.Constants.name
    
    var ready: Bool {
        return rewarded.isLoaded
    }
    
    var price: Double {
        return rewarded.auctionInfo.flatMap { $0.price }.flatMap { $0.doubleValue } ?? 0
    }
    
    private lazy var rewarded: BDMRewarded = {
        let rewarded = BDMRewarded()
        rewarded.delegate = self
        rewarded.producerDelegate = self
        return rewarded
    }()
    
    func load(_ price: Double) {
        let request = BDMRewardedRequest()
        if price > 0 {
            request.priceFloors = [price].compactMap {
                let floor = BDMPriceFloor()
                floor.id = "mediation_price"
                floor.value = NSDecimalNumber(value: $0)
                return floor
            }
        }
    
        rewarded.populate(with: request)
    }
    
    func present(_ controller: UIViewController) {
        rewarded.present(fromRootViewController: controller)
    }
}

extension BidMachineRewardedAdapter: BDMRewardedDelegate {
    
    func rewardedReady(toPresent rewarded: BDMRewarded) {
        self.loadingDelegate.flatMap { $0.didLoad(self) }
    }
    
    func rewarded(_ rewarded: BDMRewarded, failedWithError error: Error) {
        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
    }
    
    func rewarded(_ rewarded: BDMRewarded, failedToPresentWithError error: Error) {
        self.presentingDelegate.flatMap { $0.didFailPresent(self, error) }
    }
    
    func rewardedWillPresent(_ rewarded: BDMRewarded) {
        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func rewardedDidDismiss(_ rewarded: BDMRewarded) {
        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func rewardedRecieveUserInteraction(_ rewarded: BDMRewarded) {
        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
    }
    
    func rewardedFinishRewardAction(_ rewarded: BDMRewarded) {
        self.presentingDelegate.flatMap { $0.didTrackReward(self) }
    }
}

extension BidMachineRewardedAdapter: BDMAdEventProducerDelegate {
    
    func didProduceUserAction(_ producer: BDMAdEventProducer) {
        
    }
    
    func didProduceImpression(_ producer: BDMAdEventProducer) {
        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
    }
}
