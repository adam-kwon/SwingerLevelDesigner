//
//  FinalPlatform.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "FinalPlatform.h"

@implementation FinalPlatform

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"finalPlatform" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFinalPlatform;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"FinalPlatform";
}

@end
