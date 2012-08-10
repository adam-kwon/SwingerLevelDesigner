//
//  Elephant.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Elephant.h"

@implementation Elephant

@synthesize leftEdge;
@synthesize rightEdge;
@synthesize walkVelocity;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"ElephantWalk6" anchorPoint:ap];
    self.gameObjectType = kGameObjectTypeElephant;
    
    return self;
}

- (void) updateInfo {
//    if (selected) {
//        [super updateInfo];
//        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
//        [appDelegate.leftEdge setStringValue:[NSString stringWithFormat:@"%.2f", self.leftEdge]];
//        [appDelegate.rightEdge setStringValue:[NSString stringWithFormat:@"%.2f", self.rightEdge]];
//        [appDelegate.walkVelocity setStringValue:[NSString stringWithFormat:@"%.2f", self.walkVelocity]];
//    }
}

- (void) updateProperties {
//    if (selected) {
//        [super updateProperties];
//        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
//        self.leftEdge = [appDelegate.leftEdge floatValue];
//        self.rightEdge = [appDelegate.rightEdge floatValue];
//        self.walkVelocity = [appDelegate.walkVelocity floatValue];
//    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSNumber numberWithFloat:self.leftEdge] forKey:@"LeftEdge"];
    [levelDict setObject:[NSNumber numberWithFloat:self.rightEdge] forKey:@"RightEdge"];
    [levelDict setObject:[NSNumber numberWithFloat:self.walkVelocity] forKey:@"WalkVelocity"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.leftEdge = [[level objectForKey:@"LeftEdge"] floatValue];
    self.rightEdge = [[level objectForKey:@"RightEdge"] floatValue];
    self.walkVelocity = [[level objectForKey:@"WalkVelocity"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Elephant";
}

@end
