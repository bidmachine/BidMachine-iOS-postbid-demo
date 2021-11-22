//
//  AppDelegate.m
//
//  Copyright © 2019 BidMachine. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

#warning - Make sure to add your AppLovin SDK key in the Info.plist under the "AppLovinSdkKey" key

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [self startBidMachine:^{
         // Initialize the AppLovin SDK
         [ALSdk shared].mediationProvider = ALMediationProviderMAX;
         [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
             
         }];
     }];
    
    return YES;
}

- (void)startBidMachine:(void(^)(void))completion {
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.targeting = BDMTargeting.new;
    config.targeting.storeId = @"12345";
    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:completion];
}

@end
