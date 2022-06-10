//
//  AppDelegate.m
//
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

#warning - Make sure to add your AppLovin SDK key in the Info.plist under the "AppLovinSdkKey" key
#warning - Make sure to add your Google SDK key in the Info.plist under the "GADApplicationIdentifier" key

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [BMMNetworkRegistration.shared registerNetwork:BMMNetworDefines.bidmachine.klass : @{@"sourceId" : @"1",
                                                                                         @"testMode" : @"true",
                                                                                         @"storeId"  : @"1111",
                                                                                       }];
    
//     [self startBidMachine:^{
//         // Initialize the AppLovin SDK
//         [ALSdk shared].mediationProvider = ALMediationProviderMAX;
//         [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
//             
//         }];
//         
//         [GADMobileAds.sharedInstance startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
//             
//         }];
//     }];
    
    return YES;
}

@end
