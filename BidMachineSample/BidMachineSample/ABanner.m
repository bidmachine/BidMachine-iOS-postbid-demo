//
//  ABanner.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "ABanner.h"

@interface ABanner () <BMMAutorefreshBannerDelegate>

@property (weak, nonatomic) IBOutlet BMMAutorefreshBanner *autorefreshBanner;

@end

@implementation ABanner

- (void)viewDidLoad {
    [super viewDidLoad];
    [self switchState:BSStateLoading];
    
    self.autorefreshBanner.delegate = self;
    self.autorefreshBanner.controller = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.autorefreshBanner loadAd];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.autorefreshBanner hideAd];
}

#pragma mark - BMMAutorefreshBannerDelegate

- (void)autorefreshBannerDidDismissScreenAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerDidLoadAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerDidTrackImpression:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerFailToLoadAd:(BMMAutorefreshBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)autorefreshBannerFailToPresentAd:(BMMAutorefreshBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)autorefreshBannerRecieveUserAction:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerWillPresentScreenAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

@end
