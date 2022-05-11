//
//  AdProtocol.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 10.05.2022.
//

import Foundation

@objc (BMMBannerDelegate) public
protocol BannerDelegate: AnyObject {
    
    func bannerDidLoadAd(_ ad: Banner)
    
    func bannerFailToLoadAd(_ ad: Banner, with error: Error)
    
    func bannerFailToPresentAd(_ ad: Banner, with error: Error)
    
    func bannerWillPresentScreenAd(_ ad: Banner)
    
    func bannerDidDismissScreenAd(_ ad: Banner)
    
    func bannerRecieveUserAction(_ ad: Banner)
    
    func bannerDidTrackImpression(_ ad: Banner)
}

@objc (BMMAutorefreshBannerDelegate) public
protocol AutorefreshBannerDelegate: AnyObject {
    
    func autorefreshBannerDidLoadAd(_ ad: AutorefreshBanner)
    
    func autorefreshBannerFailToLoadAd(_ ad: AutorefreshBanner, with error: Error)
    
    func autorefreshBannerFailToPresentAd(_ ad: AutorefreshBanner, with error: Error)
    
    func autorefreshBannerWillPresentScreenAd(_ ad: AutorefreshBanner)
    
    func autorefreshBannerDidDismissScreenAd(_ ad: AutorefreshBanner)
    
    func autorefreshBannerRecieveUserAction(_ ad: AutorefreshBanner)
    
    func autorefreshBannerDidTrackImpression(_ ad: AutorefreshBanner)
}

@objc (BMMInterstitialDelegate) public
protocol InterstitialDelegate: AnyObject {
    
    func interstitialDidLoadAd(_ ad: Interstitial)
    
    func interstitialFailToLoadAd(_ ad: Interstitial, with error: Error)
    
    func interstitialWillPresentAd(_ ad: Interstitial)
    
    func interstitialFailToPresentAd(_ ad: Interstitial, with error: Error)
    
    func interstitialDidDismissAd(_ ad: Interstitial)
    
    func interstitialRecieveUserAction(_ ad: Interstitial)
    
    func interstitialDidTrackImpression(_ ad: Interstitial)
}

@objc (BMMRewardedDelegate) public
protocol RewardedDelegate: AnyObject {
    
    func rewardedDidLoadAd(_ ad: Rewarded)
    
    func rewardedFailToLoadAd(_ ad: Rewarded, with error: Error)
    
    func rewardedWillPresentAd(_ ad: Rewarded)
    
    func rewardedFailToPresentAd(_ ad: Rewarded, with error: Error)
    
    func rewardedDidDismissAd(_ ad: Rewarded)
    
    func rewardedRecieveUserAction(_ ad: Rewarded)
    
    func rewardedDidTrackImpression(_ ad: Rewarded)
    
    func rewardedDidTrackReward(_ ad: Rewarded)
    
}
