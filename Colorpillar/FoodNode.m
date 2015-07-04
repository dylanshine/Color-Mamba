//
//  Food.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "FoodNode.h"

#define ARC4RANDOM_MAX      0x100000000
static inline CGFloat RandomRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

@implementation FoodNode

+(instancetype) foodWithSize:(CGFloat)radius Postion:(CGSize)sceneSize Color:(UIColor *)color {
    FoodNode *_food = [self shapeNodeWithCircleOfRadius:radius];
    _food.position = CGPointMake(RandomRange(0, sceneSize.width),RandomRange(0, sceneSize.height));
    _food.fillColor = color;
    _food.name = @"food";
    _food.xScale = 0;
    _food.yScale = 0;
    
    return _food;
}

-(void) foodAnimation {
    SKAction *appear = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *disappear = [SKAction scaleTo:0.0 duration:0.5];
    SKAction *wait = [SKAction waitForDuration:7];
    SKAction *removeFromParent = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[appear, wait, disappear,removeFromParent]]];
}

@end
