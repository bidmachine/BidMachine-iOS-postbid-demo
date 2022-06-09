//
//  BidMachineBannerAdapter.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import UIKit
import BidMachine
import BidMachineMediationModule

//class BidMachineBannerAdapter: MediationAdapter {
//    
//    
//    var price: Double {
//        return banner.latestAuctionInfo.flatMap { $0.price }.flatMap { $0.doubleValue } ?? 0
//    }
//    
//    private lazy var banner: BDMBannerView = {
//        let banner = BDMBannerView()
//        banner.delegate = self
//        banner.producerDelegate = self
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        return banner
//    }()
//    
//    func load(_ price: Double) {
//        let request = BDMBannerRequest()
//        if price > 0 {
//            request.priceFloors = [price].compactMap {
//                let floor = BDMPriceFloor()
//                floor.id = "mediation_price"
//                floor.value = NSDecimalNumber(value: $0)
//                return floor
//            }
//        }
//        self.banner.populate(with: request)
//    }
//    
//    func present(_ controller: UIViewController) {
//        guard let view = self.presentingDelegate?.containerView() else {
//            self.presentingDelegate.flatMap { $0.didFailPresent(self, MediationError.presentError("BidMachine banner"))}
//            return;
//        }
//        
//        view.addSubview(banner)
//        [banner.topAnchor.constraint(equalTo: view.topAnchor),
//         banner.leftAnchor.constraint(equalTo: view.leftAnchor),
//         banner.rightAnchor.constraint(equalTo: view.rightAnchor),
//         banner.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { $0.isActive = true }
//    }
//}
//
//extension BidMachineBannerAdapter: BDMBannerDelegate {
//    
//    func bannerViewReady(toPresent bannerView: BDMBannerView) {
//        self.loadingDelegate.flatMap { $0.didLoad(self) }
//    }
//    
//    func bannerView(_ bannerView: BDMBannerView, failedWithError error: Error) {
//        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
//    }
//    
//    func bannerViewRecieveUserInteraction(_ bannerView: BDMBannerView) {
//        self.presentingDelegate.flatMap { $0.didTrackInteraction(self) }
//    }
//    
//    func bannerViewWillPresentScreen(_ bannerView: BDMBannerView) {
//        self.presentingDelegate.flatMap { $0.willPresentScreen(self) }
//    }
//    
//    func bannerViewDidDismissScreen(_ bannerView: BDMBannerView) {
//        self.presentingDelegate.flatMap { $0.didDismissScreen(self) }
//    }
//}
//
//extension BidMachineBannerAdapter: BDMAdEventProducerDelegate {
//    
//    func didProduceImpression(_ producer: BDMAdEventProducer) {
//        self.presentingDelegate.flatMap { $0.didTrackImpression(self) }
//    }
//    
//    func didProduceUserAction(_ producer: BDMAdEventProducer) {
//        
//    }
//}
