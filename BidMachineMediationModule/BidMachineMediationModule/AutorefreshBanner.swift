//
//  AutorefreshBanner.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 11.05.2022.
//

import UIKit

@objc (BMMAutorefreshBanner) public final
class AutorefreshBanner: UIView {
    
    @objc public
    weak var delegate: AutorefreshBannerDelegate?
    
    @objc public
    weak var controller: UIViewController?
    
    private var banner: Banner?
    
    @objc private var cachedBanner: Banner?
    
    private var isAdOnScreen: Bool = false
    
    private var isShowWhenLoad: Bool = false
    
    private var reloadTimer: Timer?
    
    private var refreshTimer: Timer?
    
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
        isShowWhenLoad = !isAdOnScreen
        if !isAdOnScreen, isReady {
            presentBanner()
        }
    }
}

@objc public
extension AutorefreshBanner {
    
    @objc func loadAd() {
        if !isAdOnScreen, !isReady {
            cacheBanner()
        } else if !isAdOnScreen {
            presentBanner()
        }
    }
    
    @objc func hideAd() {
        if isAdOnScreen {
            isAdOnScreen = false
            self.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    @objc var isReady: Bool {
        return cachedBanner.flatMap { $0.isReady } ?? false
    }
}

private extension AutorefreshBanner {
    
    func presentBanner() {
        isShowWhenLoad = false
        isAdOnScreen = true
        
        if refreshTimer != nil {
            return
        }
        
        guard let banner = cachedBanner, banner.isReady, controller != nil else {
            return
        }
        
        if isReady {
            self.subviews.forEach { $0.removeFromSuperview() }
            self.banner = banner
            self.addSubview(banner)
            [banner.topAnchor.constraint(equalTo: self.topAnchor),
             banner.leftAnchor.constraint(equalTo: self.leftAnchor),
             banner.rightAnchor.constraint(equalTo: self.rightAnchor),
             banner.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach { $0.isActive = true }
            
            cacheBanner()
            refreshBannerIfNeeded()
        }
    }
}

private extension AutorefreshBanner {
    
    func refreshBannerIfNeeded() {
        if refreshTimer != nil {
            return
        }
        
        if isReady {
            presentBanner()
        } else {
            refreshTimer = Timer.scheduledTimer(timeInterval: 15,
                                                target: self,
                                                selector: #selector(refreshBanner),
                                                userInfo: nil,
                                                repeats: false)
        }
    }
    
    @objc func refreshBanner() {
        refreshTimer = nil
        if isReady, isAdOnScreen {
            presentBanner()
        }
    }
}

private extension AutorefreshBanner {
    
    func cacheBannerIfNeeded() {
        if reloadTimer == nil {
            reloadTimer = Timer.scheduledTimer(timeInterval: 2,
                                               target: self,
                                               selector: #selector(cacheBanner),
                                               userInfo: nil,
                                               repeats: false)
        }
    }
    
    @objc func cacheBanner() {
        reloadTimer = nil
        cachedBanner = nil
        
        let banner = Banner(frame: self.frame)
        cachedBanner = banner
        banner.delegate = self
        banner.controller = controller
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.loadAd()
    }
    
}

extension AutorefreshBanner: BannerDelegate {
    
    public func bannerDidLoadAd(_ ad: Banner) {
        cachedBanner = ad
        if isShowWhenLoad {
            presentBanner()
        } else if isAdOnScreen {
            refreshBannerIfNeeded()
        }
        self.delegate.flatMap { $0.autorefreshBannerDidLoadAd(self) }
    }
    
    public func bannerFailToLoadAd(_ ad: Banner, with error: Error) {
        cacheBannerIfNeeded()
        self.delegate.flatMap { $0.autorefreshBannerFailToLoadAd(self, with: error) }
    }
    
    public func bannerFailToPresentAd(_ ad: Banner, with error: Error) {
        cacheBannerIfNeeded()
        self.delegate.flatMap { $0.autorefreshBannerFailToPresentAd(self, with: error) }
    }
    
    public func bannerWillPresentScreenAd(_ ad: Banner) {
        self.delegate.flatMap { $0.autorefreshBannerWillPresentScreenAd(self) }
    }
    
    public func bannerDidDismissScreenAd(_ ad: Banner) {
        self.delegate.flatMap { $0.autorefreshBannerDidDismissScreenAd(self) }
    }
    
    public func bannerRecieveUserAction(_ ad: Banner) {
        self.delegate.flatMap { $0.autorefreshBannerRecieveUserAction(self) }
    }
    
    public func bannerDidTrackImpression(_ ad: Banner) {
        self.delegate.flatMap { $0.autorefreshBannerDidTrackImpression(self) }
    }
}
