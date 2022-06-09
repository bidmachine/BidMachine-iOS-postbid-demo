//
//  Banner.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import UIKit

@objc (BMMBanner) public final
class Banner: UIView {
    
    private lazy var mediationController: MediationController = {
        let controller = MediationController()
        controller.delegate = self
        return controller
    }()
    
    private weak var _delegate: DisplayAdDelegate?
    
    private weak var _controller: UIViewController?
    
    private var wrapper: MediationAdapterWrapper?
    
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
        guard let wrapper = self.wrapper, wrapper.isReady, !isAdOnScreen else {
            return
        }
        
        present()
    }
}

extension Banner : DisplayAd {
    
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
        request.appendAdSize(.banner)
        builder(request)
        request
            .appendPlacement(.banner)
            .appendContainer(self)
            .appendController(controller)
        
        guard mediationController.isAvailable else { return }
        mediationController.loadRequest(request)
    }
    
    public func loadAd() {
        self.loadAd { _ in }
    }
}

private extension Banner {
    
    func present() {
        guard let wrapper = self.wrapper else { return }
        
        isAdOnScreen = true
        UIView.animate(withDuration: 0.3) {
            self.subviews.forEach { $0.removeFromSuperview() }
            wrapper.present(self)
        }
    }
}

extension Banner: MediationControllerDelegate {
    
    func controllerDidLoad(_ controller: MediationController, _ wrapper: MediationAdapterWrapper) {
        self.isAdOnScreen = false
        
        self.wrapper = wrapper
        self.delegate.flatMap { $0.adDidLoad(self) }
        
        if self.superview != nil {
            present()
        }
    }
    
    func controllerFailWithError(_ controller: MediationController, _ error: Error) {
        self.delegate.flatMap { $0.adFailToLoad(self, with:error) }
    }
}

extension Banner: MediationAdapterWrapperDisplayDelegate {
    
    func willPresentScreen(_ wrapper: MediationAdapterWrapper) {
        self.delegate.flatMap { $0.adWillPresentScreen(self) }
    }
    
    func didFailPresent(_ wrapper: MediationAdapterWrapper, _ error: Error) {
        self.isAdOnScreen = false
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
        
    }
}
