//
//  Banner.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

#define UNIT_ID         "ANY"

@interface Banner ()<BDMRequestDelegate, BDMBannerDelegate, MAAdViewAdDelegate>

@property (nonatomic, strong) MAAdView *applovinBanner;
@property (nonatomic, strong) BDMBannerView *banner;
@property (nonatomic, strong) BDMBannerRequest *request;

@property (weak,   nonatomic) IBOutlet UIView *container;
@property (assign, nonatomic) BOOL bannerIsLoaded;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.bannerIsLoaded = NO;
    
    [self.applovinBanner loadAd];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    
    if (self.banner.canShow) {
        [self addBanner:self.banner inContainer:self.container];
        return;
    }
    
    if (self.bannerIsLoaded) {
        [self addBanner:self.applovinBanner inContainer:self.container];
        return;
    }
}

#pragma mark - Lazy

- (MAAdView *)applovinBanner {
    if (!_applovinBanner) {
        _applovinBanner = [[MAAdView alloc] initWithAdUnitIdentifier: @UNIT_ID];
        _applovinBanner.delegate = self;
    }
    return _applovinBanner;
}

#pragma mark - Private

- (BOOL)canShow {
    return self.banner.canShow || self.bannerIsLoaded;
}

- (void)addBanner:(UIView *)banner inContainer:(UIView *)container {
    [banner removeFromSuperview];
    [container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [container addSubview:banner];
    banner.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:
        @[
          [banner.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor],
          [banner.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor],
          [banner.widthAnchor constraintEqualToConstant: 320],
          [banner.heightAnchor constraintEqualToConstant:50]
          ]];
}

- (void)makePostBidWithAd:(MAAd *)ad {
    self.request = BDMBannerRequest.new;
    if (ad.revenue > 0) {
        BDMPriceFloor *priceFloor = BDMPriceFloor.new;
        priceFloor.ID = @"applovin_max";
        priceFloor.value = [[NSDecimalNumber alloc] initWithDouble:ad.revenue * 1000];
        self.request.priceFloors = @[priceFloor];
    }
    
    [self.request performWithDelegate:self];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    self.banner = BDMBannerView.new;
    self.banner.delegate = self;
    [self.banner populateWithRequest:self.request];
    
    self.request = nil;
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    self.request = nil;
    [self switchState: self.canShow ? BSStateReady : BSStateIdle];
}

- (void)requestDidExpire:(BDMRequest *)request {
    
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    [self switchState:BSStateReady];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self switchState:self.canShow ? BSStateReady : BSStateIdle];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    
}

#pragma mark - MAAdViewAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    self.bannerIsLoaded = YES;
    [self makePostBidWithAd:ad];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    [self makePostBidWithAd:nil];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    
}

- (void)didDisplayAd:(MAAd *)ad {
    
}

- (void)didHideAd:(MAAd *)ad {
    
}

- (void)didClickAd:(MAAd *)ad {
    
}

- (void)didExpandAd:(MAAd *)ad {
    
}

- (void)didCollapseAd:(MAAd *)ad {
    
}

@end
