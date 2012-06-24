//
//  Spring.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Spring.h"

@implementation Spring

@synthesize bounce;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"spring" anchorPoint:ap];
    self.bounce = 2.0;
    self.gameObjectType = kGameObjectTypeSpring;
    
    return self;
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.bounce setStringValue:[NSString stringWithFormat:@"%.2f", self.bounce]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.bounce = [appDelegate.bounce floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSNumber numberWithFloat:self.bounce] forKey:@"Bounce"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.bounce = [[level objectForKey:@"Bounce"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Spring";
}


@end
