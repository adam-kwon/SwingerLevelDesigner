//
//  Dummy.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Dummy.h"

@implementation Dummy

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"dummy" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeDummy;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"Dummy";
}

@end
