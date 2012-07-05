//
//  StrongMan.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/5/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "StrongMan.h"

@implementation StrongMan

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"StrongmanStand1" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeWheel;
    
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        //AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        //[appDelegate.wheelSpeed setStringValue:[NSString stringWithFormat:@"%.2f", self.speed]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        //AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        //self.speed = [appDelegate.wheelSpeed floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    //[levelDict setObject:[NSNumber numberWithFloat:self.speed] forKey:@"SpinRate"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    //self.speed = [[level objectForKey:@"SpinRate"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"StrongMan";
}

@end
