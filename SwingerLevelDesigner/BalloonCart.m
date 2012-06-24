//
//  BalloonCart.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "BalloonCart.h"

@implementation BalloonCart

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"L1a_BalloonCart" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeBalloonCart;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"L1a_BalloonCart.png";
}

@end
