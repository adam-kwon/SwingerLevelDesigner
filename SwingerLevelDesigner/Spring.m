//
//  Spring.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Spring.h"
#import "Constants.h"

@implementation Spring

@synthesize bounce;

- (id) initWithAnchorPoint:(CGPoint)ap {
    self = [super initWithContentsOfFile:@"spring" anchorPoint:ap];
    self.bounce = 10.0;
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
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.bounce] forKey:@"Bounce"];
}


- (void) loadFromDict:(NSDictionary*)level {
    [super loadFromDict:level];
    
    self.bounce = [[level objectForKey:@"Bounce"] floatValue];
}

- (void) draw:(CGContextRef)ctx {        
    float angle = (45) * (M_PI/180.f);
    
    float x0 = (self.position.x + [self size].width/2)/PTM_RATIO;
    float y0 = (self.position.y + self.size.height + 47)/PTM_RATIO;
    float v01 = self.bounce + 5 + [self getWindForce:1].x;
    float v02 = self.bounce + 5 + [self getWindForce:1].y;
    float g = 30.0f;
    
    float v0x = v01 * cosf(angle);
    float v0y = v02 * sinf(angle);
    
    float range = (2*(v0x*v0y))/g;
    float t = 0;
    float stepAmt = v01/400.0f;
    
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    CGFloat dash[2] = { 3.0, 3.0 };
    [[NSColor orangeColor] set];        
    [linePath setLineDash:dash count:2 phase:0];
    [linePath setLineWidth:0.5];
    BOOL isOrigin = YES;
    while (true) {
        float xPos = (x0 + (cosf(angle)*v01*t)) * PTM_RATIO;
        float yPos = (y0 + ((sinf(angle)*v02*t) - (g/2)*(t*t))) * PTM_RATIO;
        
        t += stepAmt;
        
        if (isOrigin) {
            isOrigin = NO;
            [linePath moveToPoint:CGPointMake(xPos, yPos)];
        } else {
            [linePath lineToPoint:CGPointMake(xPos, yPos)];
        }
        
        CGContextFillRect(ctx, CGRectMake(xPos-1.5, yPos-1.5, 3, 3));
        
        if (xPos > (x0 + range)*PTM_RATIO) {
            break;
        }
    }
    
    [linePath stroke];
    
    
    [super draw:ctx];
}

- (NSString*) gameObjectTypeString {
    return @"Spring";
}


@end
