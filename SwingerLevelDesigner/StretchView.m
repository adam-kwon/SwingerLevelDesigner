//
//  StretchView.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "StretchView.h"
#import "AppDelegate.h"
#import "GameObject.h"

@interface StretchView(Private)
- (void) drawGrid:(CGContextRef)ctx;
- (void) updateSelectedInfo;
- (GameObject*)getSelectedGameObject;
@end

@implementation StretchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gameObjects = [[NSMutableArray alloc] init];
        currentPoint = CGPointZero;
        opacity = 1.0;
    }
    
    return self;
}


- (void) drawGrid:(CGContextRef)ctx {
    CGRect frame = [self frame];

    // Origin is lower left corner
    NSBezierPath *gridLinePath = [NSBezierPath bezierPath];
    //CGFloat pattern[2] = {2, 2};
    //[gridLinePath setLineDash:pattern count:2 phase:0];
    [gridLinePath moveToPoint:CGPointMake(10, 0)];
    [gridLinePath lineToPoint:CGPointMake(10, frame.size.height)];
    
    [[NSColor grayColor] set];
    [gridLinePath setLineWidth:0.2];
    [gridLinePath stroke];
    
    
    CGContextSaveGState(ctx);
    
    for (int i = 1; i < frame.size.width/10; i++) {
        CGContextTranslateCTM(ctx, 10, 0);
        [gridLinePath stroke];
    }
    
    CGContextRestoreGState(ctx);
    

    // Origin is lower left corner
    gridLinePath = [NSBezierPath bezierPath];
    //CGFloat pattern[2] = {2, 2};
    //[gridLinePath setLineDash:pattern count:2 phase:0];
    [gridLinePath moveToPoint:CGPointMake(0, 10)];
    [gridLinePath lineToPoint:CGPointMake(frame.size.width, 10)];
    
    [[NSColor grayColor] set];
    [gridLinePath setLineWidth:0.2];
    [gridLinePath stroke];
    
    
    CGContextSaveGState(ctx);
    
    for (int i = 1; i < frame.size.height/10; i++) {
        CGContextTranslateCTM(ctx, 0, 10);
        [gridLinePath stroke];
    }
    
    CGContextRestoreGState(ctx);

}

- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];

    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];

    [self drawGrid:ctx];
        
    for (GameObject *gameObject in gameObjects) {
        [gameObject draw:ctx];
    }
}


- (GameObject*) getSelectedGameObject {
    for (GameObject *gameObject in gameObjects) {
        if (gameObject.selected) {
            return gameObject;
        }
    }       
    return nil;
}

- (void) updateSelectedInfo {
    GameObject *gameObject = [self getSelectedGameObject];
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [appDelegate.xPosition setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.position.x]];
    [appDelegate.yPosition setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.position.y]];
}

- (void) updateSelectedPosition:(CGPoint)newPos {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.position = newPos;
    [self setNeedsDisplay:YES];
}

#pragma mark Accessors

- (void) addGameObject:(GameObject*)gameObject {
    gameObject.position = CGPointZero;
    gameObject.selected = YES;
    [gameObjects addObject:gameObject];
    [self updateSelectedInfo];
    [self setNeedsDisplay:YES];
}

- (float) opacity {
    return opacity;
}

- (void) setOpacity:(float)x {
    opacity = x;
    [self setNeedsDisplay:YES];
}

#pragma mark Events
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    downPoint = [self convertPoint:p fromView:nil];
    currentPoint = downPoint;
    
    for (GameObject *gameObject in gameObjects) {
        CGRect imageRect = [gameObject imageRect];
        if (CGRectContainsPoint(imageRect, downPoint)) {
            gameObject.selected = YES;
        }
    }

    
//    NSLog(@"mouseDown: %f %f   imagepos: %f %f", downPoint.x, downPoint.y, image.position.x, image.position.y);


    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self autoscroll:theEvent];
    [self setNeedsDisplay:YES];
    GameObject *gameObject = [self getSelectedGameObject];
    if (gameObject != nil) {
        CGFloat deltaX = currentPoint.x - downPoint.x;
        CGFloat deltaY = currentPoint.y - downPoint.y;
        
        gameObject.position = CGPointMake(gameObject.position.x + deltaX, gameObject.position.y + deltaY);
        downPoint = currentPoint;
        
        [self updateSelectedInfo];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    p = [self convertPoint:p fromView:nil];
    
    for (GameObject *gameObject in gameObjects) {
        CGRect imageRect = [gameObject imageRect];
        if (!CGRectContainsPoint(imageRect, p)) {
            gameObject.selected = NO;
        }
    }

    [self setNeedsDisplay:YES];
}



#pragma mark Keyboard stuff
- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
    GameObject *gameObject = [self getSelectedGameObject];
    switch ([theEvent keyCode]) {
        case 126:       // up arrow
            gameObject.position = CGPointMake(gameObject.position.x, gameObject.position.y + 1);
            [self updateSelectedInfo];
            break;
        case 125:       // down arrow
            gameObject.position = CGPointMake(gameObject.position.x, gameObject.position.y - 1);
            [self updateSelectedInfo];
            break;
        case 124:       // right arrow
            gameObject.position = CGPointMake(gameObject.position.x + 1, gameObject.position.y);
            [self updateSelectedInfo];
            break;
        case 123:       // left arrow
            gameObject.position = CGPointMake(gameObject.position.x - 1, gameObject.position.y);
            [self updateSelectedInfo];
            break;
        case 51:        // delete key
            [gameObjects removeObject:gameObject];
            break;
        default:
            NSLog(@"Key pressed: %@", theEvent);
            break;
    }
    [self setNeedsDisplay:YES];
//    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertText:(NSString*)insertString {
    
}
     
@end
