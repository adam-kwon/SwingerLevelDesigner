//
//  Hunter.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 8/10/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Hunter.h"

@implementation Hunter

@synthesize walkDistance;
@synthesize walkVelocity;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"hunter-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeHunter;
    
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.walkDistance setStringValue:[NSString stringWithFormat:@"%.2f", self.walkDistance]];
        [appDelegate.walkVelocity setStringValue:[NSString stringWithFormat:@"%.2f", self.walkVelocity]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.walkDistance = [appDelegate.walkDistance floatValue];
        self.walkVelocity = [appDelegate.walkVelocity floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.walkDistance] forKey:@"WalkDistance"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.walkVelocity] forKey:@"WalkSpeed"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.walkDistance = [[level objectForKey:@"WalkDistance"] floatValue];
    self.walkVelocity = [[level objectForKey:@"WalkSpeed"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Hunter";
}

@end
