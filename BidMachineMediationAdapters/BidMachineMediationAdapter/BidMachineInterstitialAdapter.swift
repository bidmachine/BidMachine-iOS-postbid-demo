//
//  BidMachineInterstitialAdapter.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import UIKit
import BidMachine
import BidMachineMediationModule

//class BidMachineInterstitialAdapter: NSObject, MediationAdapter {
//    
//    weak var loadingDelegate: MediationAdapterLoadingDelegate?
//    
//    weak var presentingDelegate: MediationAdapterPresentingDelegate?
//    
//    var name: String = BidMachineNework.Constants.name
//    
//    var ready: Bool {
//        return interstitial.isLoaded
//    }
//    
//    var price: Double {
//        return interstitial.auctionInfo.flatMap { $0.price }.flatMap { $0.doubleValue } ?? 0
//    }
//    
//    private lazy var interstitial: BDMInterstitial = {
//        let interstitial = BDMInterstitial()
//        interstitial.delegate = self
//        interstitial.producerDelegate = self
//        return interstitial
//    }()
//    
//    func load(_ price: Double) {
//        let request = BDMInterstitialRequest()
//        if price > 0 {
//            request.priceFloors = [price].compactMap {
//                let floor = BDMPriceFloor()
//                floor.id = "mediation_price"
//                floor.value = NSDecimalNumber(value: $0)
//                return floor
//            }
//        }
//    
//        interstitial.populate(with: request)
//    }
//    
//    func present(_ controller: UIViewController) {
//        interstitial.present(fromRootViewController: controller)
//    }
//}
//
//extension BidMachineInterstitialAdapter: BDMInterstitialDelegate {
//    
//    func interstitialReady(toPresent interstitial: BDMInterstitial) {
//        self.loadingDelegate.flatMap { $0.didLoad(self) }
//    }
//    
//    func interstitial(_ interstitial: BDMInterstitial, failedWithError error: Error) {
//        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
//    }
//    
//    func interstitial(_ interstitial: BDMInterstitial, failedToPresentWithError error: Error) {
//        self.presentingDelegate.flatMap { $0.didFailPresent(self, error) }
//    }
//    
//    func interstitialWillPresent(_ interstitial: BDMInterstitial) {
//        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
//    }
//    
//    func interstitialDidDismiss(_ interstitial: BDMInterstitial) {
//        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
//    }
//    
//    func interstitialRecieveUserInteraction(_ interstitial: BDMInterstitial) {
//        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
//    }
//}
//
//extension BidMachineInterstitialAdapter: BDMAdEventProducerDelegate {
//    
//    func didProduceUserAction(_ producer: BDMAdEventProducer) {
//        
//    }
//    
//    func didProduceImpression(_ producer: BDMAdEventProducer) {
//        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
//    }
//}
