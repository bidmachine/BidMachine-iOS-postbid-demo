//
//  BMMediationBanner.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BMMediationBanner;

@protocol BMMediationBannerDisplayDelegate <NSObject>

- (void)didClick;

- (void)didImpression;

- (void)didExpand;

- (void)didCollapse;

@end

@protocol BMMediationBannerLoadingDelegate <NSObject>

- (void)didLoadBanner:(BMMediationBanner *)banner;

- (void)didFailToLoadWithError:(NSError *)error;

@end

@protocol BMMediationBanner <NSObject>

@property (nonatomic, weak) id<BMMediationBannerDisplayDelegate> displayDelegate;

@property (nonatomic, assign, readonly) double ECPM;

- (UIView *)banner;

@end

@interface BMMediationBanner : NSObject <BMMediationBanner>

@property (nonatomic, weak) id<BMMediationBannerLoadingDelegate> delegate;

@property (nonatomic, weak) id<BMMediationBannerDisplayDelegate> displayDelegate;

@property (nonatomic, assign, readonly) double ECPM;

- (void)loadWithPriceFloor:(double)priceFloor;

@end

@interface BMMAXMediationBanner : BMMediationBanner

@end

@interface BMBidMachineMediationBanner : BMMediationBanner

@end

NS_ASSUME_NONNULL_END
