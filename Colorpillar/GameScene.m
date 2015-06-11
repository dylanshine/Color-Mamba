//
//  GameScene.m
//  Colorpillar
//
//  Created by Dylan Shine on 6/11/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{
    SKSpriteNode *_colorpillar;
    NSString *_currentDirection;
    NSDictionary *_directions;
    NSMutableArray *_bodyNodes;
    UIColor *_currentColor;
    NSArray *_colors;
    NSUInteger _lives;
    SKLabelNode *_scoreBoard;
}


@end
