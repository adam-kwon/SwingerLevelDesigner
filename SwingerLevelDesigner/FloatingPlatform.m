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
@synthesize speed;
@synthesize distance;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"floatingPlatform" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFloatingPlatform;
    
    return self;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    self.width = originalSize.width * scaleX;
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.width] forKey:@"Width"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.speed] forKey:@"ElevatorSpeed"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.distance] forKey:@"ElevatorDistance"];
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.platformWidth setStringValue:[NSString stringWithFormat:@"%.2f", self.width]];
        [appDelegate.platformSpeed setStringValue:[NSString stringWithFormat:@"%.2f", self.speed]];
        [appDelegate.platformDistance setStringValue:[NSString stringWithFormat:@"%.2f", self.distance]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.speed = [appDelegate.platformSpeed floatValue];
        self.width = [appDelegate.platformWidth floatValue];
        self.distance = [appDelegate.platformDistance floatValue];
    }
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.width = [[level objectForKey:@"Width"] floatValue];
    self.scaleX = self.width / originalSize.width;
    
    self.speed = [[level objectForKey:@"ElevatorSpeed"] floatValue];
    self.distance = [[level objectForKey:@"ElevatorDistance"] floatValue];
}


- (NSString*) gameObjectTypeString {
    return @"FloatingPlatform";
}


@end
