//
//  Block.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Block.h"

@implementation Block

@synthesize width;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"block-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFloatingPlatform;
    
    return self;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    self.width = originalSize.width * scaleX;
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.width] forKey:@"Width"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.width = [[level objectForKey:@"Width"] floatValue];
    self.scaleX = self.width / originalSize.width;
}


- (NSString*) gameObjectTypeString {
    return @"Block";
}


@end
