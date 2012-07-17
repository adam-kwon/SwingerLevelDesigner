//
//  Cannon.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Cannon.h"

@implementation Cannon

@synthesize cannonForce;
@synthesize cannonSpeed;
@synthesize cannonRotationAngle;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"Cannon" anchorPoint:ap];
    self.cannonSpeed = 2.0;
    self.cannonForce = 15;
    self.cannonRotationAngle = 45;
    self.gameObjectType = kGameObjectTypeCannon;
    
    return self;
}

- (void) draw:(CGContextRef)ctx {    
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    float x1, x2, y1, y2;
    
    x1 = position.x + [self size].width/2 + 30;
    y1 = position.y + 190;
    
    x2 = position.x + [self size].width/2 + 30 + 200*cos((90-cannonRotationAngle)*M_PI/180);
    
    // divide by poleScale to keep length same regardless of whether pole is scaled
    y2 = position.y + 190 + (200*sin((90-cannonRotationAngle)*M_PI/180)/scale);        
    [linePath moveToPoint:CGPointMake(x1, y1)];
    [linePath lineToPoint:CGPointMake(x2, y2)];
    
    [[NSColor blueColor] set];
    [linePath setLineWidth:2.0];
    [linePath stroke];
    
    float PTM_RATIO = 64.0f;
    float angle = (90-45) * (M_PI/180.f);
    if (cannonRotationAngle < 45) {
        angle = (90-cannonRotationAngle) * (M_PI/180.f);        
    }
    
    CGPoint origin = CGPointMake(self.size.width, self.size.width);
    float x0 = (origin.x/PTM_RATIO) * cosf(angle);
    float y0 = (origin.y/PTM_RATIO) * sinf(angle);
    float v01 = self.cannonForce + 4 + [self getWindForce:1].x;
    float v02 = self.cannonForce + 4 + [self getWindForce:1].y;
    float g = 30.0f + 5.0f;
    
    float v0x = v01 * cosf(angle);
    float v0y = v02 * sinf(angle);
    
    float range = (2*(v0x*v0y))/g;
    float t = 0;
    float stepAmt = v01/400.0f;
    
    while (true) {
        float xPos = (x0 + (cosf(angle)*v01*t)) * PTM_RATIO;
        float yPos = (y0 + ((sinf(angle)*v02*t) - (g/2)*(t*t))) * PTM_RATIO;
        
        NSLog(@"%f, %f", xPos, yPos);
        t += stepAmt;
        
        if (xPos > (x0 + range)*PTM_RATIO) {
            break;
        }

        CGContextFillRect(ctx, CGRectMake(xPos, yPos, 5, 5));
    }
    
    
    [super draw:ctx];
}

- (void) updateInfo {
    if (selected) {
        [super updateInfo];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.cannonForce setStringValue:[NSString stringWithFormat:@"%.2f", self.cannonForce]];
        [appDelegate.cannonSpeed setStringValue:[NSString stringWithFormat:@"%.2f", self.cannonSpeed]];
        [appDelegate.cannonRotationAngle setStringValue:[NSString stringWithFormat:@"%.2f", self.cannonRotationAngle]];
    }
}

- (void) updateProperties {
    if (selected) {
        [super updateProperties];
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.cannonSpeed = [appDelegate.cannonSpeed floatValue];
        self.cannonRotationAngle = [appDelegate.cannonRotationAngle floatValue];
        self.cannonForce = [appDelegate.cannonForce floatValue];
   
    }
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [super levelForSerialization:levelDict];
    
    [levelDict setObject:[NSNumber numberWithFloat:self.cannonSpeed] forKey:@"Speed"];
    [levelDict setObject:[NSNumber numberWithFloat:self.cannonForce] forKey:@"Force"];
    [levelDict setObject:[NSNumber numberWithFloat:self.cannonRotationAngle] forKey:@"RotationAngle"];
}

- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.cannonForce = [[level objectForKey:@"Force"] intValue];
    self.cannonRotationAngle = [[level objectForKey:@"RotationAngle"] floatValue];
    self.cannonSpeed = [[level objectForKey:@"Speed"] floatValue];
    
}

- (NSString*) gameObjectTypeString {
    return @"Cannon";
}

@end
