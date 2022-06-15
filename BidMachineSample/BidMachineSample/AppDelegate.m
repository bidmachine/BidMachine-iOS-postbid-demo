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
    
    BDMSdkConfiguration *configuration = BDMSdkConfiguration.new;
    BDMTargeting *targeting = BDMTargeting.new;
    
    targeting.storeId = @"1111";
    configuration.testMode = false;
    configuration.targeting = targeting;
    
    __weak typeof(self) weakSelf = self;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"1" configuration:configuration completion:^{
        ALSdk.shared.mediationProvider = ALMediationProviderMAX;
        [ALSdk.shared initializeSdk];
        
        [GADMobileAds.sharedInstance startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            [weakSelf registerNetworks];
        }];
    }];
    
    return YES;
}

- (void)registerNetworks {
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.applovin.klass : @{}];
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.admob.klass : @{}];
    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.bidmachine.klass : @{}];
}

@end
