//
//  Magnet.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 8/5/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Magnet.h"

@implementation Magnet

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"magnet-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeMagnet;
    
    return self;
}

- (NSString*) gameObjectTypeString {
    return @"Magnet";
}

@end
