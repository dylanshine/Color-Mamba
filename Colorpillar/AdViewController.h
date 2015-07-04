//
//  AdViewController.h
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MoPub/MPInterstitialAdController.h>
#import <SpriteKit/SpriteKit.h>

@interface AdViewController : UIViewController  <MPInterstitialAdControllerDelegate>

@property (nonatomic, retain) MPInterstitialAdController *interstitial;

@end
