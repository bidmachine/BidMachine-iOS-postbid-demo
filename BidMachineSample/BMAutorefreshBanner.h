//
//  BMAutorefreshBanner.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BMAutorefreshBanner;

@protocol BMAutorefreshBannerDelegate <NSObject>

- (void)didLoadBanner:(BMAutorefreshBanner *)banner;

- (void)didFailToLoadBanner:(BMAutorefreshBanner *)banner withError:(NSError *)error;

- (void)didClickBanner:(BMAutorefreshBanner *)banner;

- (void)didImpressionBanner:(BMAutorefreshBanner *)banner;

- (void)didExpandBanner:(BMAutorefreshBanner *)banner;

- (void)didCollapseBanner:(BMAutorefreshBanner *)banner;

@end

@interface BMAutorefreshBanner : UIView

@property (nonatomic, weak) id<BMAutorefreshBannerDelegate> delegate;

- (void)loadAd;

- (void)hideAd;

- (BOOL)isLoaded;

@end

NS_ASSUME_NONNULL_END
