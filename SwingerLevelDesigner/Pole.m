//
//  Pole.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Pole.h"

@implementation Pole

@synthesize period;
@synthesize swingAngle;
@synthesize ropeLength;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"SwingPole1" anchorPoint:ap];
    self.period = 2.0;
    self.swingAngle = 55;
    self.ropeLength = 150;
    self.gameObjectType = kGameObjectTypeSwinger;
        
    return self;
}

- (void) draw:(CGContextRef)ctx {    
    // Factor used to scale rope length so that it matches length seen in game.
    // This is just eye-balled. Saw what the ratio of rope length to pole length was in game.
    float ropeHeightConversionFactor = [self size].height / 300;
    
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    //CGFloat pattern[2] = {2, 2};
    //[gridLinePath setLineDash:pattern count:2 phase:0];
    
    float x1, x2, y1, y2;
    x1 = position.x + [self size].width/2 - anchorXOffset;
    y1 = position.y + [self size].height;
    
    x2 = position.x + [self size].width/2 - anchorXOffset + (ropeHeightConversionFactor*ropeLength*sin(swingAngle*M_PI/180))/scale;
    
    // divide by poleScale to keep length same regardless of whether pole is scaled
    y2 = position.y + [self size].height - (ropeHeightConversionFactor*ropeLength*cos(swingAngle*M_PI/180)/scale);
    [linePath moveToPoint:CGPointMake(x1, y1)];
    [linePath lineToPoint:CGPointMake(x2, y2)];
    
    [[NSColor blueColor] set];
    [linePath setLineWidth:2.0];
    [linePath stroke];
    
    [super draw:ctx];
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.period setStringValue:[NSString stringWithFormat:@"%.2f", self.period]];
        [appDelegate.ropeLength setStringValue:[NSString stringWithFormat:@"%.2f", self.ropeLength]];
        [appDelegate.swingAngle setStringValue:[NSString stringWithFormat:@"%.2f", self.swingAngle]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.period = [appDelegate.period floatValue];
        self.swingAngle = [appDelegate.swingAngle floatValue];
        self.ropeLength = [appDelegate.ropeLength floatValue];
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSNumber numberWithFloat:self.period] forKey:@"Period"];
    [levelDict setObject:[NSNumber numberWithFloat:self.ropeLength] forKey:@"RopeLength"];
    [levelDict setObject:[NSNumber numberWithFloat:self.swingAngle] forKey:@"SwingAngle"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.period = [[level objectForKey:@"Period"] floatValue];
    self.ropeLength = [[level objectForKey:@"RopeLength"] floatValue];
    self.swingAngle = [[level objectForKey:@"SwingAngle"] floatValue];
}

- (NSString*) gameObjectTypeString {
    return @"Catcher";
}


@end
