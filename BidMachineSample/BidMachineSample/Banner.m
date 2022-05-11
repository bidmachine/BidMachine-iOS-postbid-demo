//
//  Banner.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

@interface Banner ()<BMMBannerDelegate>

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
    
    [self.banner loadAd];
}

#pragma mark - BMMBannerDelegate

- (void)bannerDidLoadAd:(BMMBanner * _Nonnull)ad {
    [self switchState:BSStateIdle];
}

- (void)bannerFailToLoadAd:(BMMBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    [self switchState:BSStateIdle];
}

- (void)bannerFailToPresentAd:(BMMBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    [self switchState:BSStateIdle];
}

- (void)bannerWillPresentScreenAd:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerDidDismissScreenAd:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerDidTrackImpression:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerRecieveUserAction:(BMMBanner * _Nonnull)ad {
    
}



@end
