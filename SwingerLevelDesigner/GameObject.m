//
//  GameObject.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize position;
@synthesize selected;

- (CGRect) imageRect {
    CGRect rect = CGRectMake(position.x, position.y, self.size.width, self.size.height);
    return rect;
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
    }
}

@end
