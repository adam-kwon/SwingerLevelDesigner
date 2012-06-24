//
//  Wheel.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Wheel.h"

@implementation Wheel
@synthesize speed;


- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"wheel" anchorPoint:ap];
    self.speed = 2.0;
    self.gameObjectType = kGameObjectTypeWheel;
    
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.wheelSpeed setStringValue:[NSString stringWithFormat:@"%.2f", self.speed]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.speed = [appDelegate.wheelSpeed floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSNumber numberWithFloat:self.speed] forKey:@"SpinRate"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.speed = [[level objectForKey:@"SpinRate"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Wheel";
}

@end
