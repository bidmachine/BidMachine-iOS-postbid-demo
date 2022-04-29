//
//  BMOperation.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "BMMediationBanner.h"

@import StackFoundation;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BMOperationCompletion)( NSArray <BMMediationBanner *> *_Nullable);

@interface BMOperation : STKOperation

- (instancetype)initWithMediationBanner:(BMMediationBanner *)mediationBanner;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end

@interface BMPrebidOperation : BMOperation

@end

@interface BMPostBidOperation : BMOperation

@end

@interface BMCompletionOperation : STKOperation

- (instancetype)initWithCompletion:(BMOperationCompletion)completion;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
