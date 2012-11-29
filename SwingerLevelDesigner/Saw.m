//
//  Saw.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Saw.h"

@implementation Saw

@synthesize speed;
@synthesize width;


- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"sawBlade-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeSaw;
    
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.walkDistance setStringValue:[NSString stringWithFormat:@"%.2f", self.width]];
        [appDelegate.walkVelocity setStringValue:[NSString stringWithFormat:@"%.2f", self.speed]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.speed = [appDelegate.walkVelocity floatValue];
        self.width = [appDelegate.walkDistance floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.width] forKey:@"FlyDistance"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.speed] forKey:@"FlySpeed"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.width = [[level objectForKey:@"FlyDistance"] floatValue];
    self.speed = [[level objectForKey:@"FlySpeed"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Saw";
}


@end
