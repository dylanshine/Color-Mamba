//
//  Food.h
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FoodNode : SKShapeNode

+(instancetype)foodWithSize:(CGFloat)radius Postion:(CGSize)sceneSize Color:(UIColor *)color;
-(void) foodAnimation;
@end
