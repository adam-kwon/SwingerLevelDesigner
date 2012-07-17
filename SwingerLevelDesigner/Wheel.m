//
//  Wheel.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Wheel.h"
#import "Constants.h"

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

- (void) draw:(CGContextRef)ctx {        
    [[NSColor blackColor] set];
    
    float angle = (45) * (M_PI/180.f);
    
    float x0 = (self.position.x + 150)/PTM_RATIO;
    float y0 = (self.position.y + self.size.height/2 + 30)/PTM_RATIO;
    float v01 = self.speed*10 + 4 + [self getWindForce:1].x;
    float v02 = self.speed*10 + 4 + [self getWindForce:1].y;
    float g = 30.0f;
    
    float v0x = v01 * cosf(angle);
    float v0y = v02 * sinf(angle);
    
    float range = (2*(v0x*v0y))/g + 2;
    float t = 0;
    float stepAmt = v01/400.0f;
    
    while (true) {
        float xPos = (x0 + (cosf(angle)*v01*t)) * PTM_RATIO;
        float yPos = (y0 + ((sinf(angle)*v02*t) - (g/2)*(t*t))) * PTM_RATIO;
        
        t += stepAmt;
        
        if (xPos > (x0 + range)*PTM_RATIO) {
            break;
        }
        
        CGContextFillRect(ctx, CGRectMake(xPos, yPos, 5, 5));
    }
    
    
    [super draw:ctx];
}

- (NSString*) gameObjectTypeString {
    return @"Wheel";
}

@end
