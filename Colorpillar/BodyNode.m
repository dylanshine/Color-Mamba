//
//  BodyNode.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "BodyNode.h"

@implementation BodyNode

+(instancetype) bodyWithSize:(CGFloat)radius Color:(UIColor *)color {
    BodyNode *_body = [self shapeNodeWithCircleOfRadius:radius];
    _body.fillColor = color;
    _body.name = @"body";
    _body.zPosition = 100;
    
    return _body;
}


@end
