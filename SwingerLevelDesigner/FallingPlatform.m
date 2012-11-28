//
//  FallingPlatform.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "FallingPlatform.h"

@implementation FallingPlatform

@synthesize width;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"floatingPlatform" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFallingPlatform;
    
    return self;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    self.width = originalSize.width * scaleX;
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.width] forKey:@"Width"];
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.platformWidth setStringValue:[NSString stringWithFormat:@"%.2f", self.width]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.width = [appDelegate.platformWidth floatValue];
    }
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.width = [[level objectForKey:@"Width"] floatValue];
    self.scaleX = self.width / originalSize.width;
    
}


- (NSString*) gameObjectTypeString {
    return @"FallingPlatform";
}

@end
