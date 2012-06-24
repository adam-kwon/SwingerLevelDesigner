//
//  Boxes.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Boxes.h"

@implementation Boxes

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"L1a_Boxes1" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeBoxes;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"L1a_Boxes1.png";
}

@end
