//
//  Interstitial.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"

@interface Interstitial ()<BMMDisplayAdDelegate>

@property (nonatomic, strong) BMMInterstitial *intestitial;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.intestitial = BMMInterstitial.new;
    self.intestitial.delegate = self;
    self.intestitial.controller = self;
    
    [self.intestitial loadAd:^(id<BMMAdRequest> builder) {
        [builder appendAdUnit:BMMNetworDefines.bidmachine.name : @{}];
    }];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.intestitial present];
}

#pragma mark - BMMDisplayAdDelegate

- (void)adDidLoad:(id<BMMDisplayAd> _Nonnull)ad {
    [self switchState:BSStateReady];
}

- (void)adFailToLoad:(id<BMMDisplayAd> _Nonnull)ad with:(NSError * _Nonnull)error {
    [self switchState:BSStateIdle];
}

- (void)adFailToPresent:(id<BMMDisplayAd> _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)adWillPresentScreen:(id<BMMDisplayAd> _Nonnull)ad {
    
}

- (void)adDidDismissScreen:(id<BMMDisplayAd> _Nonnull)ad {
    
}

- (void)adDidExpired:(id<BMMDisplayAd> _Nonnull)ad {
    
}


- (void)adDidTrackImpression:(id<BMMDisplayAd> _Nonnull)ad {
    
}


- (void)adRecieveUserAction:(id<BMMDisplayAd> _Nonnull)ad {
    
}


@end
