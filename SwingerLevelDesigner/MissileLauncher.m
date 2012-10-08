//
//  MissileLauncher.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "MissileLauncher.h"

@implementation MissileLauncher

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"missile-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeHunter;
    
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"MissileLauncher";
}


@end
