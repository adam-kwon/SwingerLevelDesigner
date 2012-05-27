//
//  StretchView.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        path = [NSBezierPath bezierPath];
        [path setLineWidth:3.0];
        
        NSPoint p = [self randomPoint];
        [path moveToPoint:p];
        
        for (int i = 0; i < 15; i++) {
            p = [self randomPoint];
            [path lineToPoint:p];
        }
        
        [path closePath];
        
    }
    
    return self;
}

- (NSPoint) randomPoint {
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + arc4random() % (int)r.size.width;
    result.y = r.origin.y + arc4random() % (int)r.size.height;
    return result;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor whiteColor] set];
    [path stroke];
}

#pragma mark Events
- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"mouseDown: %ld", [theEvent clickCount]);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    NSLog(@"mouseDragged: %@", NSStringFromPoint(p));
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSLog(@"mouseUp");
}
@end
