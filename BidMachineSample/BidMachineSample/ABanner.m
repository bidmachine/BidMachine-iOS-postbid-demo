//
//  ABanner.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "ABanner.h"

@interface ABanner () <BMMDisplayAdDelegate>

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

#pragma mark - BMMDisplayAdDelegate

- (void)adDidLoad:(id<BMMDisplayAd> _Nonnull)ad {
    
}

- (void)adFailToLoad:(id<BMMDisplayAd> _Nonnull)ad with:(NSError * _Nonnull)error {
    
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
