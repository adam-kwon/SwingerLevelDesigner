//
//  Insect.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 10/7/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Insect.h"

@implementation Insect

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"insect-hd" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeInsect;
    self.speed = 2.0;
    self.width = 0.0;
    return self;
}


- (NSString*) gameObjectTypeString {
    return @"Insect";
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
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.speed] forKey:@"FlyDistance"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.width] forKey:@"FlySpeed"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.speed = [[level objectForKey:@"SpinRate"] floatValue];
}

@end
