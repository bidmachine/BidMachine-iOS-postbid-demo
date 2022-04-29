//
//  NSArray+BMBidCompare.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "NSArray+BMBidCompare.h"

@import StackFoundation;

@implementation NSArray (BMBidCompare)

- (id)bm_maxPriceBanner:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))block {
    __block id result = nil;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = STK_RUN_BLOCK(block, result, obj);
    }];
    
    return result;
}

@end
