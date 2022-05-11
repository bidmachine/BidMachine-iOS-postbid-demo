//
//  Rewarded.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

@interface Rewarded ()<BMMRewardedDelegate>

@property (nonatomic, strong) BMMRewarded *rewarded;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.rewarded = BMMRewarded.new;
    self.rewarded.delegate = self;
    [self.rewarded loadAd];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.rewarded presentFrom:self];
}

#pragma mark - BMMRewardedDelegate

- (void)rewardedDidLoadAd:(BMMRewarded *)ad {
    [self switchState:BSStateReady];
}

- (void)rewardedFailToLoadAd:(BMMRewarded *)ad with:(NSError *)error {
    [self switchState:BSStateIdle];
}

- (void)rewardedFailToPresentAd:(BMMRewarded * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)rewardedWillPresentAd:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedDidDismissAd:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedDidTrackImpression:(BMMRewarded * _Nonnull)ad {
    
}


- (void)rewardedDidTrackReward:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedRecieveUserAction:(BMMRewarded * _Nonnull)ad {
    
}


@end
