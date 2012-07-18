//
//  FloatingPlatform.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/17/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "FloatingPlatform.h"

@implementation FloatingPlatform

@synthesize width;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"floatingPlatform" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFloatingPlatform;
    
    return self;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    self.width = originalSize.width * scaleX;
    [levelDict setObject:[NSNumber numberWithFloat:self.width] forKey:@"Width"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.width = [[level objectForKey:@"Width"] floatValue];
    self.scaleX = self.width / originalSize.width;
}


- (NSString*) gameObjectTypeString {
    return @"FloatingPlatform";
}


@end
