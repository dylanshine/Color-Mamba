//
//  GameScene.m
//  Colorpillar
//
//  Created by Dylan Shine on 6/11/15.
//  Copyright (c) 2015 Dylan Shine. All rights reserved.
//

#import "GameScene.h"
#import "Colorpillar.h"
#import "FoodNode.h"
#import "BodyNode.h"
#import "ScoreBoard.h"
#import "GameOverScene.h"


static const CGFloat kNodeSize = 10.0;
static const NSUInteger kLives = 3;

@interface GameScene()
@property (nonatomic) Colorpillar *colorpillar;
@property (nonatomic) NSUInteger lives;
@property (nonatomic) ScoreBoard *scoreBoard;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) NSArray *colors;
@property (nonatomic) NSMutableArray *bodyNodes;
@property (nonatomic) NSDictionary *directions;
@property (nonatomic) BOOL transitioning;
@end

@implementation GameScene


-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor whiteColor];
        self.transitioning = NO;
        self.colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
        self.lives = kLives;
        self.bodyNodes = [[NSMutableArray alloc]init];
        self.directions = @{@"up": [SKAction moveBy:CGVectorMake(0, 3) duration:0.3],
                                    @"down": [SKAction moveBy:CGVectorMake(0, -3) duration:0.3],
                                    @"left": [SKAction moveBy:CGVectorMake(-3, 0) duration:0.3],
                                    @"right": [SKAction moveBy:CGVectorMake(3, 0) duration:0.3]};
        
        self.currentColor = [self makeRandomColor];
        
        
        
        self.colorpillar = [Colorpillar colorpillarWithSize:kNodeSize
                                                   Position:self.size
                                                  Direction:@"up"
                                                      Color:self.currentColor];
        [self addChild:self.colorpillar];
        
        self.scoreBoard = [[ScoreBoard alloc] initWithPosition:self.size];
        [self addChild:self.scoreBoard];
        
        [self runAction:[SKAction repeatActionForever:
                         [SKAction sequence:@[[SKAction performSelector:@selector(spawnFood) onTarget:self], [SKAction waitForDuration:1.0]]]] withKey:@"spawnFood"];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [NSThread sleepForTimeInterval:1.0];
}

-(void)update:(NSTimeInterval)currentTime {
    [self moveColorpillar];
    [self scoreUpdate];
    [self followColorpillar];
}

-(void)didEvaluateActions {
    [self checkFoodCollisions];
    [self checkIfLost];
    
}


-(void)moveColorpillar {
    [self.colorpillar runAction:self.directions[self.colorpillar.currentDirection]];
}

-(void)turnColorpillarToward:(CGPoint)location {
    
    if ([self.colorpillar.currentDirection isEqualToString:@"up"] || [self.colorpillar.currentDirection isEqualToString:@"down"]) {
        if (self.colorpillar.position.x > location.x) {
            self.colorpillar.currentDirection = @"left";
        } else {
            self.colorpillar.currentDirection = @"right";
        }
        return;
    }
    
    if ([self.colorpillar.currentDirection isEqualToString:@"left"] || [self.colorpillar.currentDirection isEqualToString:@"right"]) {
        if (self.colorpillar.position.y > location.y) {
            self.colorpillar.currentDirection = @"down";
        } else {
            self.colorpillar.currentDirection = @"up";
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
    FoodNode *food = [FoodNode foodWithSize:kNodeSize Postion:self.size Color:[self makeRandomColor]];
    
    CGRect largerFrame = CGRectInset(food.frame, -40, -40);
    if (CGRectIntersectsRect(self.colorpillar.frame, largerFrame)) {
        return;
    }
    
    [self addChild:food];
    [food foodAnimation];
}

-(UIColor *)makeRandomColor {
    NSUInteger randomIndex = arc4random() % [self.colors count];
    return self.colors[randomIndex];
}

-(void)setGameColor {
    self.currentColor = [self makeRandomColor];
    self.colorpillar.fillColor = self.currentColor;
}

-(void)checkFoodCollisions {
    [self enumerateChildNodesWithName:@"food" usingBlock:^(SKNode *node, BOOL *stop){
        FoodNode *food = (FoodNode *)node;
        if (CGRectIntersectsRect(food.frame, self.colorpillar.frame) && ([self.currentColor isEqual:food.fillColor])) {
            [food removeFromParent];
            BodyNode *body = [BodyNode bodyWithSize:10 Color:self.currentColor];
            [self setGameColor];
            
            CGPoint lastPoint;
            if (self.bodyNodes.count == 0) {
                lastPoint = self.colorpillar.position;
            } else {
                lastPoint = [[self.bodyNodes lastObject] position];
            }
            
            if ([self.colorpillar.currentDirection isEqualToString:@"up"]) {
                lastPoint.y -= kNodeSize;
                body.position = lastPoint;
            }
            
            if ([self.colorpillar.currentDirection isEqualToString:@"down"]) {
                lastPoint.y += kNodeSize;
                body.position = lastPoint;
            }
            
            if ([self.colorpillar.currentDirection isEqualToString:@"left"]) {
                lastPoint.x -= kNodeSize;
                body.position = lastPoint;
            }
            
            if ([self.colorpillar.currentDirection isEqualToString:@"right"]) {
                lastPoint.x += kNodeSize;
                body.position = lastPoint;
            }
            
            [self.bodyNodes addObject:body];
            [self addChild:body];
        } else if (CGRectIntersectsRect(food.frame, self.colorpillar.frame) && (![self.currentColor isEqual:food.fillColor])){
            [food removeFromParent];
            self.lives--;
            [self setGameColor];
        }
    }];
}

-(void)followColorpillar {
    for (NSUInteger i = 0; i < self.bodyNodes.count; i++) {
        SKAction *action;
        if (i == 0) {
            action = [SKAction moveTo:self.colorpillar.position duration:0.1];
        } else {
            action = [SKAction moveTo:[self.bodyNodes[i - 1] position] duration:0.1];
        }
        [self.bodyNodes[i] runAction:action];
    }
}

-(BOOL)checkBodyCollisions {
    for (NSUInteger i = 3; i < self.bodyNodes.count; i++) {
        if (CGRectIntersectsRect([self.bodyNodes[i] frame], self.colorpillar.frame) && (i != self.bodyNodes.count - 1)) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)boundsCheck {
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(self.size.width,self.size.height);
    
    if (self.colorpillar.position.x <= bottomLeft.x + 9 || self.colorpillar.position.x >= topRight.x - 9 || self.colorpillar.position.y <= bottomLeft.y + 9 || self.colorpillar.position.y >= topRight.y - 9) {
        return YES;
    }
    return NO;
}

-(void)checkIfLost {
    if (self.lives == 0 || [self boundsCheck] || [self checkBodyCollisions]) {
        if (!self.transitioning) {
            self.transitioning = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(self.bodyNodes.count) forKey:@"score"];
            [defaults synchronize];
            
            [self removeAllActions];
            [self removeAllChildren];
            
            GameOverScene *gameOverScene = [GameOverScene sceneWithSize:self.frame.size];
            [self.view presentScene:gameOverScene transition:nil];
  
        }
    }
}

-(void)scoreUpdate {
    NSString *livesString = [NSString stringWithFormat:@"Score: %lu Lives: %lu", (unsigned long)self.bodyNodes.count, (unsigned long)self.lives];
    self.scoreBoard.text = livesString;
}


@end



