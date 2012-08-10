//
//  FireRing.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 7/20/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "FireRing.h"

@implementation FireRing
@synthesize moveX;
@synthesize moveY;
@synthesize frequency;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"FireRing" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeFireRing;
    self.moveX = 0.0;
    self.moveY = 0.0;
    self.frequency = 1.0;
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.moveX setStringValue:[NSString stringWithFormat:@"%.2f", self.moveX]];
        [appDelegate.moveY setStringValue:[NSString stringWithFormat:@"%.2f", self.moveY]];
        [appDelegate.frequency setStringValue:[NSString stringWithFormat:@"%.2f", self.frequency]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.moveX = [appDelegate.moveX floatValue];
        self.moveY = [appDelegate.moveY floatValue];
        self.frequency = [appDelegate.frequency floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.moveX] forKey:@"MoveX"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.moveY] forKey:@"MoveY"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.frequency] forKey:@"Frequency"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.moveX = [[level objectForKey:@"MoveX"] floatValue];
    self.moveY = [[level objectForKey:@"MoveY"] floatValue];
    self.frequency = [[level objectForKey:@"Frequency"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"FireRing";
}


@end
