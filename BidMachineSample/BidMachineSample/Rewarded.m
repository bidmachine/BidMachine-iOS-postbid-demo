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
        [builder appendAdUnit:BMMNetworDefines.bidmachine.name : @{}];
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
