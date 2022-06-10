//
//  Rewarded.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

@interface Rewarded ()<BMMDisplayAdDelegate>

@property (nonatomic, strong) BMMRewarded *rewarded;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.rewarded = BMMRewarded.new;
    self.rewarded.delegate = self;
    self.rewarded.controller = self;
    
    [self.rewarded loadAd:^(id<BMMAdRequest> builder) {
        [builder appendTimeout:10 by:BMMTypePrebid];
        [builder appendTimeout:10 by:BMMTypePostbid];
        [builder appendTimeout:10];
        [builder appendMediationType:BMMTypeAll];
        [builder appendPriceFloor:7];
        [builder appendAdUnit:BMMNetworDefines.bidmachine.name : @{}];
        [builder appendAdUnit:BMMNetworDefines.applovin.name : @{@"unitId" : @"YOUR_UNIT_ID"}];
        [builder appendAdUnit:BMMNetworDefines.admob.name : @{@"lineItems" : @[@{@"price" : @10, @"unitId" : @"ca-app-pub-3940256099942544/1712485313"},
                                                                               @{@"price" : @9, @"unitId" : @"ca-app-pub-3940256099942544/1712485313"},
                                                                               @{@"price" : @8, @"unitId" : @"ca-app-pub-3940256099942544/1712485313"},
                                                                               @{@"price" : @7, @"unitId" : @"ca-app-pub-3940256099942544/1712485313"},
                                                                               @{@"price" : @6, @"unitId" : @"ca-app-pub-3940256099942544/1712485313"}]}];
    }];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.rewarded present:^{
        
    }];
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
