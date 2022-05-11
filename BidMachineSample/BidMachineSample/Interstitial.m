//
//  Interstitial.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"

@interface Interstitial ()<BMMInterstitialDelegate>

@property (nonatomic, strong) BMMInterstitial *intestitial;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.intestitial = BMMInterstitial.new;
    self.intestitial.delegate = self;
    [self.intestitial loadAd];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.intestitial presentFrom:self];
}

#pragma mark - BMMInterstitialDelegate

- (void)interstitialDidLoadAd:(BMMInterstitial *)ad {
    [self switchState:BSStateReady];
}

- (void)interstitialFailToLoadAd:(BMMInterstitial *)ad with:(NSError *)error {
    [self switchState:BSStateIdle];
}

- (void)interstitialFailToPresentAd:(BMMInterstitial * _Nonnull)ad with:(NSError * _Nonnull)error {

}

- (void)interstitialWillPresentAd:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialDidDismissAd:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialDidTrackImpression:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialRecieveUserAction:(BMMInterstitial * _Nonnull)ad {
    
}

@end
