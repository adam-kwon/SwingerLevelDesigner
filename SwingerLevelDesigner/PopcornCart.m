//
//  PopcornCart.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "PopcornCart.h"

@implementation PopcornCart


- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"L1a_PopcornCart" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypePopcornCart;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"L1a_PopcornCart.png";
}

@end
