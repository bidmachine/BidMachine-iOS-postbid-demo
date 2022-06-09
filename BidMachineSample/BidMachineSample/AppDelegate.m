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
    [BMMNetworkRegistration.shared registerNetwork:@"BidMachineMediationAdapter.BidMachineNework" : @{@"sourceId" : @"5"}];
    
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

- (void)startBidMachine:(void(^)(void))completion {
    
    
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.targeting = BDMTargeting.new;
    config.targeting.storeId = @"12345";
//    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"1"
                                 configuration:config
                                    completion:completion];
}

@end
