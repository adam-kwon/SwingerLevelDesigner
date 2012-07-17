//
//  Pole.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 6/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "Pole.h"
#import "Constants.h"

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

    // Factor used to scale rope length so that it matches length seen in game.
    // This is just eye-balled. Saw what the ratio of rope length to pole length was in game.
    ropeHeightConversionFactor = [self size].height / 280;

    return self;
}

- (CGPoint) calculateJumpForce {
    float BASE_RATIO = 30.0f;
    float BASE_LENGTH = 200;
    float BASE_JUMP_X = 3.5;
    float BASE_JUMP_Y = 2.5;
    
    float scaledRopeLength = (ropeHeightConversionFactor*ropeLength)/scale;

    float lengthScale = (scaledRopeLength/BASE_LENGTH) * (scaledRopeLength/BASE_LENGTH);
    float anglePeriodScale = ((swingAngle*(M_PI/180.0f))/period/BASE_RATIO);
    float jumpForceX = BASE_JUMP_X * (lengthScale + anglePeriodScale);
    float jumpForceY = BASE_JUMP_Y * (lengthScale + anglePeriodScale);
    
    CGPoint v = CGPointMake(jumpForceX, jumpForceY);
    
    /*
    float gravity = (4 * M_PI * (ropeLength/PTM_RATIO)/(period*period));
    float angle = (swingAngle/2) * (M_PI/180.0f);
    float velocity = sqrtf(2*gravity*swingAngle/PTM_RATIO*(1-cosf(angle)));
    
    float velX = velocity * cosf(angle);
    float velY = velocity * sinf(angle);
     */
    
    return v;
}

- (void) draw:(CGContextRef)ctx {        
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
    
    
    float angle = (90-55) * (M_PI/180.f);
    if (swingAngle < 90) {
        angle = (90-swingAngle) * (M_PI/180.f);        
    }
    

    float scaledRopeLength = (ropeHeightConversionFactor*ropeLength)/scale;
    
    float x0 = (x1+fabs(scaledRopeLength) * cosf(angle))/PTM_RATIO;
    float y0 = (y1-fabs(scaledRopeLength) * sinf(angle))/PTM_RATIO;

    float v01 = [self calculateJumpForce].x + 3 + [self getWindForce:1].x;
    float v02 = [self calculateJumpForce].y + 3 + [self getWindForce:1].y;
    float g = 30.0f;
    
    float v0x = v01 * cosf(angle);
    float v0y = v02 * sinf(angle);
    
    float range = (2*(v0x*v0y))/g + 6;
    float t = 0;
    float stepAmt = v01/400.0f;
    

    CGFloat dash[2] = { 3.0, 3.0 };
    [[NSColor blueColor] set];        
    [linePath setLineDash:dash count:2 phase:30];
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

//    [linePath2 moveToPoint:CGPointMake(x5, y5)];
//    [linePath2 lineToPoint:CGPointMake(x6, y6)];
//    [linePath2 lineToPoint:CGPointMake(x7, y7)];
//    [linePath2 stroke];
    

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
