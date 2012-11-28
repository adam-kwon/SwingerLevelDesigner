//
//  OilBarrel.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 11/28/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "OilBarrel.h"

@implementation OilBarrel

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"barrel-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeOilBarrel;
    
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"Barrel";
}


@end
