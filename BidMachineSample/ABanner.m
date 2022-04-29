//
//  ABanner.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "ABanner.h"
#import "BMAutorefreshBanner.h"

@interface ABanner () <BMAutorefreshBannerDelegate>

@property (weak, nonatomic) IBOutlet BMAutorefreshBanner *autorefreshBanner;

@end

@implementation ABanner

- (void)viewDidLoad {
    [super viewDidLoad];
    [self switchState:BSStateLoading];
    
    self.autorefreshBanner.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.autorefreshBanner loadAd];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.autorefreshBanner hideAd];
}

#pragma mark - BMAutorefreshBannerDelegate


- (void)didClickBanner:(nonnull BMAutorefreshBanner *)banner {
    
}

- (void)didCollapseBanner:(nonnull BMAutorefreshBanner *)banner {
    
}

- (void)didExpandBanner:(nonnull BMAutorefreshBanner *)banner {
    
}

- (void)didFailToLoadBanner:(nonnull BMAutorefreshBanner *)banner withError:(nonnull NSError *)error {
    
}

- (void)didImpressionBanner:(nonnull BMAutorefreshBanner *)banner {
    
}

- (void)didLoadBanner:(nonnull BMAutorefreshBanner *)banner {
    
}

@end
