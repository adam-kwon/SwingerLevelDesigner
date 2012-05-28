//
//  GameObject.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize position;
@synthesize selected;
@synthesize gameObjectType;
@synthesize swingSpeed;
@synthesize moveHandleSelected;

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

- (id) initWithContentsOfFile:(NSString *)fileName {
    self = [super initWithContentsOfFile:fileName];
    moveHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-move-hi" 
                                                                                         ofType:@"png"]];
    return self;
}

- (void) draw:(CGContextRef)ctx {
    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = [self size];
    [self drawAtPoint:position fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
    
    
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

    }
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

@end
