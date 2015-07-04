//
//  BodyNode.h
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BodyNode : SKShapeNode
+(instancetype)bodyWithSize:(CGFloat)radius Color:(UIColor *)color;
@end
