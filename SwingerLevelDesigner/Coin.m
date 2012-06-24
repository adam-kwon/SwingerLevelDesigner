//
//  Coin.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"Coin1" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeCoin;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"Coin";
}


@end
