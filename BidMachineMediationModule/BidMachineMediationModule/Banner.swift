//
//  Banner.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import UIKit

@objc (BMMBanner) public final
class Banner: UIView {
    
    @objc public
    weak var delegate: BannerDelegate?
    
    @objc public
    weak var controller: UIViewController?
    
    private lazy var mediationController: MediationController = {
        let controller = MediationController()
        controller.delegate = self
        return controller
    }()
    
    private var adapter: MediationAdapter?
    
    private var isAdOnScreen: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clipsToBounds = true
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let adapter = self.adapter, adapter.ready, !isAdOnScreen else {
            return
        }
        
        present(from: controller)
    }
}

@objc public
extension Banner {
    
    @objc func loadAd() {
        guard mediationController.isAvailable else { return }
        mediationController.loadAd(.banner)
    }
    
    @objc var isReady: Bool {
        return adapter.flatMap { $0.ready } ?? false
    }
}


private extension Banner {
    
    func present(from controller: UIViewController?) {
        guard var adapter = self.adapter, let controller = controller else { return }
        adapter.presentingDelegate = self
        
        isAdOnScreen = true
        UIView.animate(withDuration: 0.3) {
            self.subviews.forEach { $0.removeFromSuperview() }
            adapter.present(controller)
        }
    }
}

extension Banner: MediationControllerDelegate {
    
    func controllerDidLoad(_ controller: MediationController, _ adapter: MediationAdapter) {
        self.isAdOnScreen = false
        
        self.adapter = adapter
        self.delegate.flatMap { $0.bannerDidLoadAd(self) }
        
        if self.superview != nil {
            present(from: self.controller)
        }
    }
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error) {
        self.delegate.flatMap { $0.bannerFailToLoadAd(self, with:error) }
    }
}

extension Banner: MediationAdapterPresentingDelegate {
    
    public func willPresentScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.bannerWillPresentScreenAd(self) }
    }
    
    public func didFailPresent(_ adapter: MediationAdapter, _ error: Error) {
        self.isAdOnScreen = false
        self.delegate.flatMap { $0.bannerFailToPresentAd(self, with: error) }
    }
    
    public func didDismissScreen(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.bannerDidDismissScreenAd(self) }
    }
    
    public func didTrackImpression(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.bannerDidTrackImpression(self) }
    }
    
    public func didTrackInteraction(_ adapter: MediationAdapter) {
        self.delegate.flatMap { $0.bannerRecieveUserAction(self) }
    }
    
    public func containerView() -> UIView? {
        return self
    }
}
