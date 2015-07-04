//
//  ScoreBoard.m
//  Colorpillar
//
//  Created by Dylan Shine on 7/3/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "ScoreBoard.h"

@implementation ScoreBoard

-(instancetype)initWithPosition:(CGSize)sceneSize {
    
    if (self = [super init]) {
        self.position = CGPointMake(sceneSize.width/2, sceneSize.height - 40);
        self.fontColor = [UIColor blackColor];
        self.fontSize = 20;
        self.zPosition = 100;
    }
    return self;
}

@end
