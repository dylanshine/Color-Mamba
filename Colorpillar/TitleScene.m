//
//  TitleScene.m
//  Color Mamba
//
//  Created by Dylan Shine on 7/4/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"title3"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *gameScene = [GameScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.7];
    [self.view presentScene:gameScene transition:transition];
}



@end
