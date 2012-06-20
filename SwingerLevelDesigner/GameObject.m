//
//  GameObject.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"
#import "AppDelegate.h"
#import "StretchView.h"

@implementation GameObject

@synthesize position;
@synthesize selected;
@synthesize gameObjectType;
@synthesize period;
@synthesize moveHandleSelected;
@synthesize resizeHandleSelected;
@synthesize ropeLength;
@synthesize grip;
@synthesize poleScale;
@synthesize windSpeed;
@synthesize swingAngle;
@synthesize windDirection;
@synthesize cannonForce;
@synthesize cannonSpeed;
@synthesize cannonRotationAngle;
@synthesize anchorYOffset;
@synthesize anchorXOffset;
@synthesize zOrder;
@synthesize anchorPoint;
@synthesize name;

- (CGRect) imageRect {
    CGRect rect = CGRectMake(position.x - anchorXOffset, position.y - anchorYOffset, self.size.width, self.size.height);
    return rect;
}

- (CGRect) moveHandleRect {
    CGRect rect = CGRectMake(position.x + [self size].width - anchorXOffset, 
                             position.y + [self size].height - [moveHandle size].height - anchorYOffset, 
                             [moveHandle size].width, 
                             [moveHandle size].height);
    return rect;
}

- (CGRect) resizeHandleRect {
    CGRect rect = CGRectMake(position.x + [self size].width - anchorXOffset, 
                             position.y + [self size].height - [moveHandle size].height*2 - anchorYOffset, 
                             [moveHandle size].width, 
                             [moveHandle size].height);
    return rect;    
}

- (id) initWithContentsOfFile:(NSString *)fileName anchorPoint:(CGPoint)ap parent:(NSView *)parentView {
    self = [super initWithContentsOfFile:fileName];
    self.windDirection = @"";
    self.poleScale = 1.0;
    self.grip = 2.0;
    self.period = 2.0;
    self.swingAngle = 55;
    self.ropeLength = 150;
    self.zOrder = 0;
    self.anchorPoint = ap;
    moveHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-move-hi" 
                                                                                         ofType:@"png"]];
    
    resizeHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-scale-hi" 
                                                                                           ofType:@"png"]];
    originalSize = [self size];

    parent = parentView;
    
    lbl = [[NSTextView alloc] initWithFrame:CGRectMake(0, 40, 400, 60)];
    [lbl setString:@""];
    [lbl setDrawsBackground:NO];
    [lbl setSelectable:NO];
    [lbl setEditable:NO];
    [lbl setFont:[NSFont fontWithName:@"Courier New" size:11]];
    [parent addSubview:lbl];
    
    return self;
}


// Origin is lower, left
- (void) draw:(CGContextRef)ctx {
    
    [self setScalesWhenResized:YES];
    CGSize newSize = CGSizeMake(originalSize.width, originalSize.height*poleScale);
    [self setSize:newSize];
    
    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = [self size];
    [self drawAtPoint:CGPointMake(position.x - anchorXOffset, position.y - anchorYOffset) 
             fromRect:imageRect 
            operation:NSCompositeSourceOver 
             fraction:1.0];        
    
    
    // Factor used to scale rope length so that it matches length seen in game.
    // This is just eye-balled. Saw what the ratio of rope length to pole length was in game.
    float ropeHeightConversionFactor = [self size].height / 300;

    NSBezierPath *linePath = [NSBezierPath bezierPath];
    //CGFloat pattern[2] = {2, 2};
    //[gridLinePath setLineDash:pattern count:2 phase:0];
    
    float x1, x2, y1, y2;
    if (gameObjectType == kGameObjectTypeSwinger) {
        x1 = position.x + [self size].width/2 - anchorXOffset;
        y1 = position.y + [self size].height;
        
        x2 = position.x + [self size].width/2 - anchorXOffset + (ropeHeightConversionFactor*ropeLength*sin(swingAngle*M_PI/180))/poleScale;
        
        // divide by poleScale to keep length same regardless of whether pole is scaled
        y2 = position.y + [self size].height - (ropeHeightConversionFactor*ropeLength*cos(swingAngle*M_PI/180)/poleScale);
        [linePath moveToPoint:CGPointMake(x1, y1)];
        [linePath lineToPoint:CGPointMake(x2, y2)];
        
        [[NSColor blueColor] set];
        [linePath setLineWidth:2.0];
        [linePath stroke];
    } else if (gameObjectType == kGameObjectTypeCannon) {
        x1 = position.x + [self size].width/2 + 30;
        y1 = position.y + 190;
        
        x2 = position.x + [self size].width/2 + 30 + 200*cos((90-cannonRotationAngle)*M_PI/180);
        
        // divide by poleScale to keep length same regardless of whether pole is scaled
        y2 = position.y + 190 + (200*sin((90-cannonRotationAngle)*M_PI/180)/poleScale);        
        [linePath moveToPoint:CGPointMake(x1, y1)];
        [linePath lineToPoint:CGPointMake(x2, y2)];
        
        [[NSColor blueColor] set];
        [linePath setLineWidth:2.0];
        [linePath stroke];
    }


    
    
    if (selected) {
        if (gameObjectType == kGameObjectTypeStar) {
            anchorXOffset = [self size].width/2;
            anchorYOffset = [self size].height/2;
            NSBezierPath *box = [NSBezierPath bezierPathWithRect:CGRectMake(self.position.x - [self size].width/2, 
                                                                            self.position.y - [self size].height/2,
                                                                            [self size].width, 
                                                                            [self size].height)];
            [[NSColor redColor] set];
            [box stroke];            
        } else {
            NSBezierPath *box = [NSBezierPath bezierPathWithRect:[self imageRect]];
            [[NSColor redColor] set];
            [box stroke];            
        }

        NSRect moveHandleRect;
        moveHandleRect.origin = NSZeroPoint;
        moveHandleRect.size = [moveHandle size];
        [moveHandle drawAtPoint:CGPointMake(self.position.x + [self size].width - anchorXOffset, 
                                            self.position.y + [self size].height - [moveHandle size].height - anchorYOffset) 
                       fromRect:moveHandleRect 
                      operation:NSCompositeSourceOver 
                       fraction:1.0];

        
        NSRect sizeHandleRect;
        sizeHandleRect.origin = NSZeroPoint;
        sizeHandleRect.size = [resizeHandle size];
        [resizeHandle drawAtPoint:CGPointMake(self.position.x + [self size].width - anchorXOffset, 
                                              self.position.y + [self size].height - [moveHandle size].height*2 - anchorYOffset)
                         fromRect:sizeHandleRect 
                        operation:NSCompositeSourceOver 
                         fraction:1.0];
    }
    
    if (gameObjectType == kGameObjectTypeSwinger) {
        NSString *str;
        
        str = [NSString stringWithFormat:@"%15s %.2f secs\n%15s %.2f\n%15s %.2f\n%15s %@", 
                         "Period:", "Grip:", "Wind speed:", "Wind direction:", period, grip, windSpeed, windDirection];
        
        [lbl setString:str];
        [lbl setFrameOrigin:CGPointMake(position.x + [self size].width, position.y)];
    } else {
        if (lbl != nil) {
            [lbl removeFromSuperview];
            lbl = nil;
        }
    }
}

- (void) setGameObjectType:(GameObjectType)type {
    gameObjectType = type;
    anchorXOffset = [self size].width * anchorPoint.x;
    anchorYOffset = [self size].height * anchorPoint.y;
}

- (void) setSize:(NSSize)aSize {
    [super setSize:aSize];
    poleScale = aSize.height / originalSize.height;
}

- (BOOL) isRectIntersectImage:(CGRect)rect {
    if (CGRectContainsRect(rect, [self imageRect])) {
        return YES;
    }
    return NO;
}

- (BOOL) isPointInImage:(CGPoint)point {
    if (CGRectContainsPoint([self imageRect], point)) {
        return YES;
    }
    return NO;
}

- (BOOL) isPointInMoveHandle:(CGPoint)point {
    if (CGRectContainsPoint([self moveHandleRect], point)) {
        return YES;
    }
    return NO;
}

- (BOOL) isPointInResizeHandle:(CGPoint)point {
    if (CGRectContainsPoint([self resizeHandleRect], point)) {
        return YES;
    }
    return NO;    
}


- (void) dealloc {
    [lbl removeFromSuperview];
}
@end
