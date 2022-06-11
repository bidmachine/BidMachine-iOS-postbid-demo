//
//  AppDelegate.m
//
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate
// Banner
//        /**
//         * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
//         * For each ad unit, you need to set up an eCPM floor and switch off auto refresh.
//         */
//        static let lineItems = [
//            LineItem(price: 1.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 2.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 3.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 4.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 5.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 6.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 7.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 8.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 9.0, unitId: "ca-app-pub-3940256099942544/2934735716"),
//            LineItem(price: 10.0, unitId: "ca-app-pub-3940256099942544/2934735716")
//        ]

// Rewarded
//        /**
//         * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
//         * For each ad unit, you need to set up an eCPM floor
//         */
//        static let lineItems = [
//            LineItem(price: 1.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 2.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 3.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 4.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 5.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 6.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 7.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 8.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 9.0, unitId: "ca-app-pub-3940256099942544/1712485313"),
//            LineItem(price: 10.0, unitId: "ca-app-pub-3940256099942544/1712485313")
//        ]

// Interstitial
//       /**
//         * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
//         * For each ad unit, you need to set up an eCPM floor
//         */
//        static let lineItems = [
//            LineItem(price: 1.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 2.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 3.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 4.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 5.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 6.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 7.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 8.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 9.0, unitId: "ca-app-pub-3940256099942544/4411468910"),
//            LineItem(price: 10.0, unitId: "ca-app-pub-3940256099942544/4411468910")
//        ]

#warning - Make sure to add your AppLovin SDK key in the Info.plist under the "AppLovinSdkKey" key
#warning - Make sure to add your Google SDK key in the Info.plist under the "GADApplicationIdentifier" key

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [BMMLogging.sharedLog enableMediationLog:YES];
    [BMMLogging.sharedLog enableAdapterLog:YES];
    [BMMLogging.sharedLog enableNetworkLog:YES];
    [BMMLogging.sharedLog enableAdCallbackLog:YES];
    
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.applovin.klass : @{}];
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.admob.klass : @{}];
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.bidmachine.klass : @{@"sourceId" : @"1",
                                                                                         @"testMode" : @"false",
                                                                                         @"storeId"  : @"1111",
                                                                                       }];
    
    return YES;
}

@end
