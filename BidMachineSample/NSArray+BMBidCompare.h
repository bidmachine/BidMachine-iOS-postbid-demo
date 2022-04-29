//
//  NSArray+BMBidCompare.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray <__covariant ObjectType> (BMBidCompare)

- (ObjectType)bm_maxPriceBanner:(ObjectType(^)(ObjectType prev, ObjectType next))block;

@end
