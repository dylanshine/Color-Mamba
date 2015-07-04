//
//  AdViewController.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "AdViewController.h"
#import "GameViewController.h"

@interface AdViewController()

@end

@implementation AdViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // fetch an interstitial ad.
    // TODO: Replace this test id with your personal ad unit id
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"77ce0b65cf81438eb255695afe3b1904"];
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];

}

#pragma mark - <MPInterstitialAdControllerDelegate>
// Present the ad only after it has loaded and is ready
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    if (interstitial.ready) {
        [interstitial showFromViewController:self];
    }
}

-(void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
