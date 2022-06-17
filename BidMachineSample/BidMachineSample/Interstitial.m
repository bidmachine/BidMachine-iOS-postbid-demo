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
        [builder appendTimeout:10];
        [builder appendPriceFloor:7];
        [builder.prebidConfig appendTimeout:1];
        [builder.postbidConfig appendTimeout:1];
        [builder.prebidConfig appendAdUnit:BMMNetworkDefines.bidmachine.name : @{}];
        [builder.postbidConfig appendAdUnit:BMMNetworkDefines.bidmachine.name : @{}];
        [builder.prebidConfig appendAdUnit:BMMNetworkDefines.applovin.name : @{@"unitId" : @"YOUR_UNIT_ID"}];
        [builder.postbidConfig appendAdUnit:BMMNetworkDefines.admob.name : @{@"lineItems" :
                                                                                @[@{@"price" : @10, @"unitId" : @"ca-app-pub-3940256099942544/4411468910"},
                                                                                  @{@"price" : @9, @"unitId" : @"ca-app-pub-3940256099942544/4411468910"},
                                                                                  @{@"price" : @8, @"unitId" : @"ca-app-pub-3940256099942544/4411468910"},
                                                                                  @{@"price" : @7, @"unitId" : @"ca-app-pub-3940256099942544/4411468910"},
                                                                                  @{@"price" : @6, @"unitId" : @"ca-app-pub-3940256099942544/4411468910"}]}];
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
