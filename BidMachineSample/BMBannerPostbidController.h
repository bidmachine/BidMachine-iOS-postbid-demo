//
//  BMBannerPostbidController.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMediationBanner.h"

NS_ASSUME_NONNULL_BEGIN

@class BMBannerPostbidController;

@protocol BMBannerPostbidControllerDelegate <NSObject>

- (void)controller:(BMBannerPostbidController *)controller didLoadBanner:(id<BMMediationBanner>)banner;

- (void)controller:(BMBannerPostbidController *)controller didFailToLoadWithError:(NSError *)error;

@end

@interface BMBannerPostbidController : NSObject

- (instancetype)initControllerWithDelegate:(id<BMBannerPostbidControllerDelegate>)delegate;

- (void)loadBanner;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
