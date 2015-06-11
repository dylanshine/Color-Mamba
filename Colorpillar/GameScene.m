//
//  GameScene.m
//  Colorpillar
//
//  Created by Dylan Shine on 6/11/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "GameScene.h"

#define ARC4RANDOM_MAX      0x100000000
static inline CGFloat RandomRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

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
        _colorpillar = [SKSpriteNode spriteNodeWithColor:[self makeRandomColor] size:CGSizeMake(20, 20)];
        _colorpillar.position = CGPointMake(self.size.width/2, self.size.height/2);
        _colorpillar.zPosition = 100;
         self.backgroundColor = [SKColor whiteColor];
        [self addChild:_colorpillar];
        
        [self runAction:[SKAction repeatActionForever:
                         [SKAction sequence:@[[SKAction performSelector:@selector(spawnFood) onTarget:self], [SKAction waitForDuration:1.0]]]] withKey:@"spawnFood"];
        
    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime {
    [self moveColorpillar];
    [self followColorpillar];
}

-(void)didEvaluateActions {
    [self checkFoodCollisions];
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

-(void)spawnFood {
    SKSpriteNode *food = [SKSpriteNode spriteNodeWithColor:[self makeRandomColor] size:CGSizeMake(20, 20)];
    food.position = CGPointMake(RandomRange(0, self.size.width),RandomRange(0, self.size.height));
    CGRect largerFrame = CGRectInset(food.frame, -40, -40);
    if (CGRectIntersectsRect(_colorpillar.frame, largerFrame)) {
        return;
    }
    food.name = @"food";
    food.xScale = 0;
    food.yScale = 0;
    [self addChild:food];
    SKAction *appear = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *disappear = [SKAction scaleTo:0.0 duration:0.5];
    SKAction *wait = [SKAction waitForDuration:7];
    SKAction *removeFromParent = [SKAction removeFromParent];
    [food runAction:[SKAction sequence:@[appear, wait, disappear,removeFromParent]]];
}

-(UIColor *)makeRandomColor {
    NSUInteger randomIndex = arc4random() % [_colors count];
    return _colors[randomIndex];
}

-(void)setGameColor {
    _currentColor = [self makeRandomColor];
    _colorpillar.color = _currentColor;
}

-(void)checkFoodCollisions {
    [self enumerateChildNodesWithName:@"food" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *food = (SKSpriteNode *)node;
        if (CGRectIntersectsRect(food.frame, _colorpillar.frame) && ([_currentColor isEqual:food.color])) {
            [food removeFromParent];
            SKSpriteNode *body = [SKSpriteNode spriteNodeWithColor:_currentColor size:CGSizeMake(20,20)];
            body.zPosition = 100;
            [self setGameColor];
            
            CGPoint lastPoint;
            if (_bodyNodes.count == 0) {
                lastPoint = _colorpillar.position;
            } else {
                lastPoint = [[_bodyNodes lastObject] position];
            }
            
            if ([_currentDirection isEqualToString:@"up"]) {
                lastPoint.y -= _colorpillar.size.height;
                body.position = lastPoint;
            }
            
            if ([_currentDirection isEqualToString:@"down"]) {
                lastPoint.y += _colorpillar.size.height;
                body.position = lastPoint;
            }
            
            if ([_currentDirection isEqualToString:@"left"]) {
                lastPoint.x -= _colorpillar.size.height;
                body.position = lastPoint;
            }
            
            if ([_currentDirection isEqualToString:@"right"]) {
                lastPoint.x += _colorpillar.size.height;
                body.position = lastPoint;
            }
            
            [_bodyNodes addObject:body];
            [self addChild:body];
        } else if (CGRectIntersectsRect(food.frame, _colorpillar.frame) && (![_currentColor isEqual:food.color])){
            [food removeFromParent];
            _lives--;
            [self setGameColor];
        }
    }];
}

-(void)followColorpillar {
    for (NSUInteger i = 0; i < _bodyNodes.count; i++) {
        SKAction *action;
        if (i == 0) {
            action = [SKAction moveTo:_colorpillar.position duration:0.1];
        } else {
            action = [SKAction moveTo:[_bodyNodes[i - 1] position] duration:0.1];
        }
        [_bodyNodes[i] runAction:action];
    }
}

-(BOOL)checkBodyCollisions {
    for (NSUInteger i = 2; i < _bodyNodes.count; i++) {
        if (CGRectIntersectsRect([_bodyNodes[i] frame], _colorpillar.frame) && (i != _bodyNodes.count - 1)) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)boundsCheck {
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(self.size.width,self.size.height);
    
    if (_colorpillar.position.x <= bottomLeft.x || _colorpillar.position.x >= topRight.x || _colorpillar.position.y <= bottomLeft.y || _colorpillar.position.y >= topRight.y) {
        return YES;
    }
    return NO;
}


@end



