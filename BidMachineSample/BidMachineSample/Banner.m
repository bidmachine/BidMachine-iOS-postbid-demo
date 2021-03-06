//
//  Banner.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

@interface Banner ()<BMMDisplayAdDelegate>

@property (weak, nonatomic) IBOutlet BMMBanner *banner;

@end

@implementation Banner

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.banner.delegate = self;
    self.banner.controller = self;
}

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    
    [self.banner loadAd:^(id<BMMAdRequest> builder) {
        [builder appendAdSize:BMMSizeBanner];
        [builder appendTimeout:10];
        [builder appendPriceFloor:7];
        [builder.prebidConfig appendAdUnit:BMMNetworkDefines.bidmachine.name : @{}];
        [builder.postbidConfig appendAdUnit:BMMNetworkDefines.bidmachine.name : @{}];
        [builder.prebidConfig appendAdUnit:BMMNetworkDefines.applovin.name : @{@"unitId" : @"YOUR_UNIT_ID"}];
        [builder.postbidConfig appendAdUnit:BMMNetworkDefines.admob.name : @{@"lineItems" :
                                                                                @[@{@"price" : @10, @"unitId" : @"ca-app-pub-3940256099942544/2934735716"},
                                                                                  @{@"price" : @9, @"unitId" : @"ca-app-pub-3940256099942544/2934735716"},
                                                                                  @{@"price" : @8, @"unitId" : @"ca-app-pub-3940256099942544/2934735716"},
                                                                                  @{@"price" : @7, @"unitId" : @"ca-app-pub-3940256099942544/2934735716"},
                                                                                  @{@"price" : @6, @"unitId" : @"ca-app-pub-3940256099942544/2934735716"}]}];
    }];
}

#pragma mark - BMMDisplayAdDelegate

- (void)adDidLoad:(id<BMMDisplayAd> _Nonnull)ad {
    [self switchState:BSStateIdle];
}

- (void)adFailToLoad:(id<BMMDisplayAd> _Nonnull)ad with:(NSError * _Nonnull)error {
    [self switchState:BSStateIdle];
}

- (void)adFailToPresent:(id<BMMDisplayAd> _Nonnull)ad with:(NSError * _Nonnull)error {
    [self switchState:BSStateIdle];
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
