//
//  GameOverScene.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "AdViewController.h"
#import "AppDelegate.h"
#import <GameKit/GameKit.h>

@interface GameOverScene() <GKGameCenterControllerDelegate>

@property (nonatomic) SKLabelNode *gameOverLabel;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *restartLabel;
@property (nonatomic) SKSpriteNode *gameCenterButton;
@property (nonatomic) BOOL addShown;
@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor redColor];
        
        self.gameOverLabel = [SKLabelNode labelNodeWithText:@"Game Over"];
        self.gameOverLabel.fontColor = [UIColor whiteColor];
        self.gameOverLabel.fontSize = 50;
        self.gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 100);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *scoreString = [NSString stringWithFormat:@"Your score was %@", [defaults objectForKey:@"score"]];
        self.scoreLabel = [SKLabelNode labelNodeWithText:scoreString];
        self.scoreLabel.fontColor = [UIColor whiteColor];
        self.scoreLabel.fontSize = 30;
        self.scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 60);
        
        
        self.restartLabel = [SKLabelNode labelNodeWithText:@"Touch Anywhere To Restart!"];
        self.restartLabel.fontColor = [UIColor whiteColor];
        self.restartLabel.fontSize = 25;
        self.restartLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - 20);
        
        self.gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"GCIcon96x96.png"];
        self.gameCenterButton.position = CGPointMake(self.size.width/2, self.size.height/2 - 150);
        self.gameCenterButton.name = @"GameCenterButton";

        
        
        [self addChild:self.gameOverLabel];
        [self addChild:self.scoreLabel];
        [self addChild:self.restartLabel];
        [self addChild:self.gameCenterButton];
        
        self.addShown = NO;
        
    }
    return self;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"GameCenterButton"]) {
        [self showLeaderboardAndAchievements:YES];
        return;
    }
    
    if (!self.addShown) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reportScore];
        });
        
        self.addShown = YES;
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController:[[AdViewController alloc] init] animated:YES completion:nil];
    } else {
        GameScene *gameScene = [GameScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:gameScene transition:transition];
    }
    
}

-(void)reportScore{
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).gameCenterEnabled) {
        NSString *leaderBoard = ((AppDelegate *)[UIApplication sharedApplication].delegate).leaderboardIdentifier;
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderBoard];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSNumber *playerScore = [defaults objectForKey:@"score"];
        
        score.value = [playerScore integerValue];
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
    
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
         NSString *leaderBoard = ((AppDelegate *)[UIApplication sharedApplication].delegate).leaderboardIdentifier;
        gcViewController.leaderboardIdentifier = leaderBoard;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // Finally present the view controller.
    [self.view.window.rootViewController presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
