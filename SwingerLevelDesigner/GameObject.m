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

- (CGRect) imageRect {
    CGRect rect = CGRectMake(position.x, position.y, self.size.width, self.size.height);
    return rect;
}

- (CGRect) moveHandleRect {
    CGRect rect = CGRectMake(position.x + [self size].width, 
                             position.y + [self size].height - [moveHandle size].height, 
                             [moveHandle size].width, 
                             [moveHandle size].height);
    return rect;
}

- (CGRect) resizeHandleRect {
    CGRect rect = CGRectMake(position.x + [self size].width, 
                             position.y + [self size].height - [moveHandle size].height*2, 
                             [moveHandle size].width, 
                             [moveHandle size].height);
    return rect;    
}

- (id) initWithContentsOfFile:(NSString *)fileName {
    self = [super initWithContentsOfFile:fileName];
    self.windDirection = @"";
    self.poleScale = 1.0;
    moveHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-move-hi" 
                                                                                         ofType:@"png"]];
    
    resizeHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-scale-hi" 
                                                                                           ofType:@"png"]];
    originalSize = [self size];
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
    [self drawAtPoint:position fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
    
    // Factor used to scale rope length so that it matches length seen in game.
    // This is just eye-balled. Saw what the ratio of rope length to pole length was in game.
    float ropeHeightConversionFactor = [self size].height / 300;

    NSBezierPath *linePath = [NSBezierPath bezierPath];
    //CGFloat pattern[2] = {2, 2};
    //[gridLinePath setLineDash:pattern count:2 phase:0];
    
    float x1, x2, y1, y2;
    if (gameObjectType == kGameObjectTypeSwinger) {
        x1 = position.x + [self size].width/2;
        y1 = position.y + [self size].height;
        
        x2 = position.x + [self size].width/2 + ropeHeightConversionFactor*ropeLength*sin(swingAngle*M_PI/180);
        
        // divide by poleScale to keep length same regardless of whether pole is scaled
        y2 = position.y + [self size].height - (ropeHeightConversionFactor*ropeLength*cos(swingAngle*M_PI/180)/poleScale);
        [linePath moveToPoint:CGPointMake(x1, y1)];
        [linePath lineToPoint:CGPointMake(x2, y2)];
        
        [[NSColor blueColor] set];
        [linePath setLineWidth:2.0];
        [linePath stroke];
    } else if (gameObjectType == kGameObjectTypeCannon) {
        x1 = position.x + [self size].width/2;
        y1 = position.y;
        
        x2 = position.x + [self size].width/2 + 200*cos(cannonRotationAngle*M_PI/180);
        
        // divide by poleScale to keep length same regardless of whether pole is scaled
        y2 = position.y + (200*sin(cannonRotationAngle*M_PI/180)/poleScale);        
        [linePath moveToPoint:CGPointMake(x1, y1)];
        [linePath lineToPoint:CGPointMake(x2, y2)];
        
        [[NSColor blueColor] set];
        [linePath setLineWidth:2.0];
        [linePath stroke];
    }


    
    
    if (selected) {
        NSBezierPath *box = [NSBezierPath bezierPathWithRect:[self imageRect]];
        [[NSColor redColor] set];
        [box stroke];

        NSRect moveHandleRect;
        moveHandleRect.origin = NSZeroPoint;
        moveHandleRect.size = [moveHandle size];
        [moveHandle drawAtPoint:CGPointMake(self.position.x + [self size].width, self.position.y + [self size].height - [moveHandle size].height) 
                       fromRect:moveHandleRect 
                      operation:NSCompositeSourceOver 
                       fraction:1.0];

        
        NSRect sizeHandleRect;
        sizeHandleRect.origin = NSZeroPoint;
        sizeHandleRect.size = [resizeHandle size];
        [resizeHandle drawAtPoint:CGPointMake(self.position.x + [self size].width, self.position.y + [self size].height - [moveHandle size].height*2)
                         fromRect:sizeHandleRect 
                        operation:NSCompositeSourceOver 
                         fraction:1.0];
    }
    


}

- (void) setSize:(NSSize)aSize {
    [super setSize:aSize];
    poleScale = aSize.height / originalSize.height;
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


@end
