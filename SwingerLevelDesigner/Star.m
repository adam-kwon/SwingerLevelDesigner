//
//  Star.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Star.h"

@implementation Star

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"star" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeStar;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"Star";
}


@end
