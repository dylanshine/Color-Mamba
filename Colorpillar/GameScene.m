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

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
        _directions = @{@"up": [SKAction moveBy:CGVectorMake(0, 3) duration:0.3],
                        @"down": [SKAction moveBy:CGVectorMake(0, -3) duration:0.3],
                        @"left": [SKAction moveBy:CGVectorMake(-3, 0) duration:0.3],
                        @"right": [SKAction moveBy:CGVectorMake(3, 0) duration:0.3]};
        _lives = 3;
        _bodyNodes = [[NSMutableArray alloc]init];
        _currentDirection = @"up";
        _colorpillar = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
        _colorpillar.position = CGPointMake(self.size.width/2, self.size.height/2);
        _colorpillar.zPosition = 100;
         self.backgroundColor = [SKColor whiteColor];
        [self addChild:_colorpillar];
        
    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime {
    [self moveColorpillar];
}


-(void)moveColorpillar {
    [_colorpillar runAction:_directions[_currentDirection]];
}

-(void)turnColorpillarToward:(CGPoint)location {
    
    if ([_currentDirection isEqualToString:@"up"] || [_currentDirection isEqualToString:@"down"]) {
        if (_colorpillar.position.x > location.x) {
            _currentDirection = @"left";
        } else {
            _currentDirection = @"right";
        }
        return;
    }
    
    if ([_currentDirection isEqualToString:@"left"] || [_currentDirection isEqualToString:@"right"]) {
        if (_colorpillar.position.y > location.y) {
            _currentDirection = @"down";
        } else {
            _currentDirection = @"up";
        }
        return;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [self turnColorpillarToward:touchLocation];
}



@end



