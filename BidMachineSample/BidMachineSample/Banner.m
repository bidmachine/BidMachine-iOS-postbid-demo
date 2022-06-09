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
        [builder appendPriceFloor:0.1];
        [builder appendAdUnit:@"BidMachine" : @{}];
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
