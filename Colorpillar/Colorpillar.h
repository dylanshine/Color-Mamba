//
//  Colorpillar.h
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Colorpillar : SKShapeNode

@property (nonatomic) NSString *currentDirection;

+(instancetype)colorpillarWithSize:(CGFloat)size
                   Position:(CGSize)sceneSize
                  Direction:(NSString *)direction
                      Color:(UIColor *)color;

@end
