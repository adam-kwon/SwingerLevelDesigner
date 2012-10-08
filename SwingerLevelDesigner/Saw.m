//
//  Saw.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Saw.h"

@implementation Saw


- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"sawBlade-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeHunter;
    
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"Saw";
}


@end
