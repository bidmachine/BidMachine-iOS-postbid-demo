//
//  Rewarded.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation
import UIKit

public typealias RewardCompletion = () -> Void

@objc (BMMRewarded) public
class Rewarded: NSObject {
    
    private lazy var mediationController: MediationController = {
        let controller = MediationController()
        controller.delegate = self
        return controller
    }()
    
    private weak var _delegate: DisplayAdDelegate?
    
    private weak var _controller: UIViewController?
    
    private var wrapper: MediationAdapterWrapper?
    
    private var reward: RewardCompletion?
}

extension Rewarded: DisplayAd {
    
    public var delegate: DisplayAdDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
    
    public var controller: UIViewController? {
        get { return _controller }
        set { _controller = newValue }
    }

    public var isReady: Bool {
        return wrapper.flatMap { $0.isReady } ?? false
    }
    
    public func loadAd(_ builder: RequestBuilder) {
        let request: Request = Request()
        builder(request)
        request
            .appendPlacement(.rewarded)
            .appendController(controller)
        
        guard mediationController.isAvailable else { return }
        mediationController.loadRequest(request)
    }
    
    public func loadAd() {
        self.loadAd { _ in }
    }
    
    @objc public func present(_ reward: @escaping RewardCompletion) {
        guard let wrapper = self.wrapper else {
            self.delegate.flatMap { $0.adFailToPresent(self, with: MediationError.presentError("Adapter not found")) }
            return;
        }
        
        self.reward = reward
        wrapper.present(self)
    }
}

extension Rewarded: MediationControllerDelegate {
    
    func controllerDidLoad(_ controller: MediationController, _ wrapper: MediationAdapterWrapper) {
        self.wrapper = wrapper
        self.delegate.flatMap { $0.adDidLoad(self) }
    }
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error) {
        self.delegate.flatMap { $0.adFailToLoad(self, with:error) }
    }
}

extension Rewarded: MediationAdapterWrapperDisplayDelegate {
    
    func willPresentScreen(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adWillPresentScreen(self) }
    }
    
    func didFailPresent(_ wrapper: MediationAdapterWrapper, _ error: Error) {
        self.delegate.flatMap { $0.adFailToPresent(self, with: error) }
    }
    
    func didDismissScreen(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adDidDismissScreen(self) }
    }
    
    func didTrackImpression(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adDidTrackImpression(self) }
    }
    
    func didTrackInteraction(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adRecieveUserAction(self) }
    }
    
    func didTrackExpired(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adDidExpired(self) }
    }
    
    func didTrackReward(_ wrapper: MediationAdapterWrapper) {
        self.reward?()
    }
}

