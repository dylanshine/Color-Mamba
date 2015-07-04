//
//  Colorpillar.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "ColorMamba.h"
#import <SpriteKit/SpriteKit.h>

@implementation ColorMamba

+(instancetype)colorpillarWithSize:(CGFloat)radius
                   Position:(CGSize)sceneSize
                  Direction:(NSString *)direction
                      Color:(UIColor *)color {
    
    ColorMamba *_colorpillar = [self shapeNodeWithCircleOfRadius:radius];
    _colorpillar.position = CGPointMake(sceneSize.width/2, sceneSize.height/2);
    _colorpillar.fillColor = color;
    _colorpillar.strokeColor = [UIColor blackColor];
    _colorpillar.lineWidth = 1.0;
    _colorpillar.glowWidth = 1.0;
    _colorpillar.zPosition = 100;
    _colorpillar.currentDirection = direction;
    

    
    return _colorpillar;
}

@end
