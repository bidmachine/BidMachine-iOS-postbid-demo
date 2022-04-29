//
//  BMBannerPostbidController.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "BMBannerPostbidController.h"
#import "NSArray+BMBidCompare.h"
#import "BMOperation.h"

@import BidMachine;
@import BidMachine.HeaderBidding;

@interface BMBannerPostbidController ()

@property (nonatomic, weak, readonly) id<BMBannerPostbidControllerDelegate> delegate;

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) BOOL isAvailable;

@end

@implementation BMBannerPostbidController

- (instancetype)initControllerWithDelegate:(id<BMBannerPostbidControllerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _isAvailable = YES;
    }
    return self;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = NSOperationQueue.new;
        _queue.name = @"com.bidmachine.postbid.demo.queue";
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

#pragma mark - Public

- (void)loadBanner {
    if (!self.isAvailable) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    BMOperationCompletion completion = ^(NSArray<BMMediationBanner *> *mediationBanners) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isAvailable = YES;
            [weakSelf completeWithMediationBanners:mediationBanners];
        });
    };
    
    NSOperation *prebidOperation = [[BMPrebidOperation alloc] initWithMediationBanner: BMMAXMediationBanner.new];
    NSOperation *postbidOperation = [[BMPostBidOperation alloc] initWithMediationBanner: BMBidMachineMediationBanner.new];
    NSOperation *completionOperation = [[BMCompletionOperation alloc] initWithCompletion:completion];
    
    [postbidOperation addDependency:prebidOperation];
    [completionOperation addDependency:postbidOperation];
    
    self.isAvailable = NO;
    [self.queue addOperations:@[prebidOperation, postbidOperation, completionOperation] waitUntilFinished:NO];
}

#pragma mark - Private

- (void)completeWithMediationBanners:(NSArray<BMMediationBanner *> *)mediationBanners {
    BMMediationBanner *winner = [mediationBanners bm_maxPriceBanner:^BMMediationBanner *(BMMediationBanner *prev, BMMediationBanner *next) {
        return next.ECPM >= prev.ECPM ? next : prev;
    }];
    
    if (winner) {
        [self.delegate controller:self didLoadBanner:winner];
    } else {
        NSError *error = [NSError bdm_errorWithCode:BDMErrorCodeNoContent description:@"Can't load mediaton banner"];
        [self.delegate controller:self didFailToLoadWithError:error];
    }
}

@end
