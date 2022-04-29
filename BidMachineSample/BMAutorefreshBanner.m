//
//  BMAutorefreshBanner.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "BMAutorefreshBanner.h"
#import "BMBannerPostbidController.h"

@import StackUIKit;

@interface BMAutorefreshBanner ()<BMBannerPostbidControllerDelegate, BMMediationBannerDisplayDelegate>

@property (nonatomic, strong) BMBannerPostbidController *postbidController;

@property (nonatomic, strong) id<BMMediationBanner> banner;
@property (nonatomic, strong) id<BMMediationBanner> cachedBanner;

@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) NSTimer *reloadTimer;

@property (nonatomic, assign) BOOL adOnScreen;
@property (nonatomic, assign) BOOL showWhenLoad;

@end

@implementation BMAutorefreshBanner

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.postbidController = [[BMBannerPostbidController alloc] initControllerWithDelegate:self];
    [self configureAppearance];
}

- (void)configureAppearance {
    self.clipsToBounds = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.showWhenLoad = !self.adOnScreen;
    if (!self.adOnScreen && self.isLoaded) {
        [self presentBanner];
    }
}

#pragma mark - Public

- (void)loadAd {
    if (!self.adOnScreen && !self.cachedBanner) {
        [self cacheBanner];
    }
}

- (BOOL)isLoaded {
    return self.cachedBanner != nil;
}

#pragma mark - Private

- (void)cacheBannerIfNeeded {
    if (!self.reloadTimer) {
        self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cacheBanner) userInfo:nil repeats:NO];
    }
}

- (void)refreshBannerIfNeeded {
    if (self.refreshTimer) {
        return;
    }
    
    if (self.isLoaded) {
        [self presentBanner];
    } else {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
    }
}

- (void)presentBanner {
    self.showWhenLoad = NO;
    self.adOnScreen = YES;
    
    if (self.refreshTimer) {
        return;
    }
    
    if (self.isLoaded) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.banner = self.cachedBanner;
            [self.banner.banner stk_edgesEqual:self];
            [self cacheBanner];
            [self refreshBannerIfNeeded];
        }];
    }
}

- (void)cacheBanner {
    self.reloadTimer = nil;
    self.cachedBanner = nil;
    
    [self.postbidController loadBanner];
}

- (void)refresh {
    self.refreshTimer = nil;
    if (self.isLoaded && self.adOnScreen) {
        [self presentBanner];
    }
}

#pragma mark - BMBannerPostbidControllerDelegate

- (void)controller:(BMBannerPostbidController *)controller didLoadBanner:(id<BMMediationBanner>)banner {
    self.cachedBanner = banner;
    self.cachedBanner.displayDelegate = self;
    if (self.showWhenLoad) {
        [self presentBanner];
    } else  if (self.adOnScreen) {
        [self refreshBannerIfNeeded];
    }
    [self.delegate didLoadBanner:self];
}

- (void)controller:(BMBannerPostbidController *)controller didFailToLoadWithError:(NSError *)error {
    [self cacheBannerIfNeeded];
    [self.delegate didFailToLoadBanner:self withError:error];
}

#pragma mark - BMMediationBannerDisplayDelegate

- (void)didClick {
    [self.delegate didClickBanner:self];
}

- (void)didImpression {
    [self.delegate didImpressionBanner:self];
}

- (void)didExpand {
    [self.delegate didExpandBanner:self];
}

- (void)didCollapse {
    [self.delegate didCollapseBanner:self];
}

@end
