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

@interface GameOverScene()

@property (nonatomic) SKLabelNode *gameOverLabel;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKLabelNode *restartLabel;
@property (nonatomic) BOOL addShown;
@end

@implementation GameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor redColor];
        
        self.gameOverLabel = [SKLabelNode labelNodeWithText:@"Game Over"];
        self.gameOverLabel.fontColor = [UIColor whiteColor];
        self.gameOverLabel.fontSize = 50;
        self.gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *scoreString = [NSString stringWithFormat:@"Your score was %@", [defaults objectForKey:@"score"]];
        self.scoreLabel = [SKLabelNode labelNodeWithText:scoreString];
        self.scoreLabel.fontColor = [UIColor whiteColor];
        self.scoreLabel.fontSize = 30;
        self.scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - 40);
        
        
        self.restartLabel = [SKLabelNode labelNodeWithText:@"Touch To Play Again!"];
        self.restartLabel.fontColor = [UIColor whiteColor];
        self.restartLabel.fontSize = 30;
        self.restartLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - 100);
        
        [self addChild:self.gameOverLabel];
        [self addChild:self.scoreLabel];
        [self addChild:self.restartLabel];
        
        self.addShown = NO;
        
    }
    return self;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.addShown) {
        self.addShown = YES;
        UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController:[[AdViewController alloc] init] animated:YES completion:nil];
    } else {
        GameScene *gameScene = [GameScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:gameScene transition:transition];
    }
    
}

@end
