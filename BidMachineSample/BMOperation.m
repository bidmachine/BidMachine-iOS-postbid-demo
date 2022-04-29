//
//  BMOperation.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "BMOperation.h"
#import "NSArray+BMBidCompare.h"

@interface BMOperation ()<BMMediationBannerLoadingDelegate>

@property (nonatomic, strong, readwrite) NSArray <BMMediationBanner *> *banners;

@property (nonatomic, strong, readonly) BMMediationBanner *mediationBanner;

- (void)_perform;

@end

@interface BMCompletionOperation ()

@property (nonatomic, assign, readonly) BMOperationCompletion completion;

@end

/// IMPLEMENTATION

@implementation BMOperation

- (instancetype)initWithMediationBanner:(BMMediationBanner *)mediationBanner {
    if (self = [super init]) {
        _mediationBanner = mediationBanner;
        _mediationBanner.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        self.executionBlock = ^(STKOperation *operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.class.stk_isValid(operation)) {
                    [weakSelf _perform];
                } else {
                    [weakSelf complete];
                }
            });
        };
    }
    return self;
}

- (void)_perform {
    [self complete];
}

#pragma mark - BMMediationBannerLoadingDelegate

- (void)didLoadBanner:(BMMediationBanner *)banner {
    [self populateBannersWithArrayOfBanners:@[banner]];
    [self complete];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self complete];
}

- (void)populateBannersWithArrayOfBanners:(NSArray <BMMediationBanner *> *)banners {
    if (!banners) {
        return;
    }
    NSMutableArray *newBanners = self.banners ? self.banners.mutableCopy : NSMutableArray.new;
    [newBanners addObjectsFromArray:banners];
    self.banners = newBanners;
}

@end


@implementation BMPrebidOperation

- (void)_perform {
    [self.mediationBanner loadWithPriceFloor:0];
}

@end


@implementation BMPostBidOperation

- (void)_perform {
    BMOperation *operation = (BMOperation *)self.dependencies.firstObject;
    if (BMOperation.stk_isValid(operation)) {
        self.banners = operation.banners;
    }
    
    double priceFloor = [self.banners bm_maxPriceBanner:^BMMediationBanner *(BMMediationBanner *prev, BMMediationBanner *next) {
        return next.ECPM >= prev.ECPM ? next : prev;
    }].ECPM;
    
    [self.mediationBanner loadWithPriceFloor:priceFloor];
}

@end

@implementation BMCompletionOperation

- (instancetype)initWithCompletion:(BMOperationCompletion)completion {
    if (self = [super init]) {
        _completion = completion;
        __weak typeof(self) weakSelf = self;
        self.executionBlock = ^(STKOperation *operation) {
            if (weakSelf.class.stk_isValid(operation)) {
                [weakSelf _perform];
            } else {
                STK_RUN_BLOCK(completion, @[]);
                [weakSelf complete];
            }
        };
    }
    return self;
}

- (void)_perform {
    BMOperation *operation = (BMOperation *)self.dependencies.firstObject;
    NSArray *banners = nil;
    if (BMOperation.stk_isValid(operation)) {
        banners = operation.banners;
    }
    
    STK_RUN_BLOCK(self.completion, banners);
    [self complete];
}

@end
