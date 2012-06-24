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
- (void) updateDisplay:(id)p;
- (GameObject*) getSelectedGameObject;
- (GameObject*) getMoveHandleSelectedGameObject;
- (GameObject*) getResizeHandleSelectedGameObject;
@end

@implementation StretchView

@synthesize deviceScreenHeight;
@synthesize deviceScreenWidth;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gameObjects = [[NSMutableArray alloc] init];
        currentPoint = CGPointZero;
        opacity = 1.0;
        scale = 1.0;
        
        deviceScreenWidth = 480*2;
        deviceScreenHeight = 320*2;
        
        selectionRect = CGRectMake(0, 0, 0, 0);
        //[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(updateDisplay:) userInfo:nil repeats:YES];
    }
    
    return self;
}


- (void) updateDisplay:(id)p {
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

    
    CGContextSaveGState(ctx);
    [[NSColor blueColor] set];
    for (int i = 0; i < frame.size.width/deviceScreenWidth; i++) {
        CGContextTranslateCTM(ctx, deviceScreenWidth, 0);
        [gridLinePath stroke];
    }    
    CGContextRestoreGState(ctx);

    
    CGContextSaveGState(ctx);    
    [gridLinePath moveToPoint:CGPointMake(0, 0)];
    [gridLinePath lineToPoint:CGPointMake(frame.size.width, 0)];
    [[NSColor blueColor] set];
    for (int i = 0; i < frame.size.height/deviceScreenHeight; i++) {
        CGContextTranslateCTM(ctx, 0, deviceScreenHeight);
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
    //NSLog(@"HERHEREHRE");
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];

    NSRect bounds = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:bounds];

    [self drawGrid:ctx];
        
    for (GameObject *gameObject in gameObjects) {
        [gameObject draw:ctx];
    }
    
    if (startSelection) {
        NSBezierPath *box = [NSBezierPath bezierPathWithRect:selectionRect];
        [[NSColor redColor] set];
        [box stroke];            
    }

}


- (IBAction)zoomIn:(id)sender {
    scale += 0.025;

    NSSize s = [self convertSize:NSMakeSize(1,1) fromView:nil];
    [self scaleUnitSquareToSize:s];    

    [self scaleUnitSquareToSize:CGSizeMake(scale, scale)];
    [self setNeedsDisplay:YES];
}
- (IBAction)zoomOut:(id)sender {
    scale -= 0.025;
    
    NSSize s = [self convertSize:NSMakeSize(1,1) fromView:nil];
    [self scaleUnitSquareToSize:s];    
    
    [self scaleUnitSquareToSize:CGSizeMake(scale, scale)];    
    [self setNeedsDisplay:YES];
}

- (IBAction)resetZoom:(id)sender {
    scale = 1.0;
    
    NSSize s = [self convertSize:NSMakeSize(1,1) fromView:nil];
    [self scaleUnitSquareToSize:s];    
    
    [self scaleUnitSquareToSize:CGSizeMake(scale, scale)];    
    [self setNeedsDisplay:YES];    
}


#pragma mark Game Object selection and manipulation

- (GameObject*) getResizeHandleSelectedGameObject {
    for (GameObject *gameObject in gameObjects) {
        if (gameObject.resizeHandleSelected) {
            return gameObject;
        }
    }       
    return nil;    
}

- (GameObject*) getMoveHandleSelectedGameObject {
    for (GameObject *gameObject in gameObjects) {
        if (gameObject.moveHandleSelected) {
            return gameObject;
        }
    }       
    return nil;    
}

- (GameObject*) getSelectedGameObject {
    for (GameObject *gameObject in gameObjects) {
        if (gameObject.selected) {
            return gameObject;
        }
    }       
    return nil;
}

- (void) updateSelectedGameObject {
    for (GameObject *go in gameObjects) {
        [go  updateProperties];
    }    

}
- (void) updateSelectedInfo {
    for (GameObject *go in gameObjects) {
        [go  updateInfo];
    }
}

- (void) unselectAllGameObjects {
    for (GameObject *gameObject in gameObjects) {
        gameObject.selected = NO;
        gameObject.moveHandleSelected = NO;
        gameObject.resizeHandleSelected = NO;
    }    
}


#pragma mark Accessors

- (void) addGameObject:(GameObject *)gameObject isSelected:(BOOL)selected {    
    gameObject.selected = selected;
    [gameObjects addObject:gameObject];
    [self sortGameObjectsByZOrder];
    [self updateSelectedInfo];
    [self setNeedsDisplay:YES];
}

- (GameObject*) getLastGameObject {
    GameObject *maxGameObject = [gameObjects objectAtIndex:0];
    for (int i = 1; i < [gameObjects count]; i++) {
        GameObject *go = [gameObjects objectAtIndex:i];
        if (go.position.x > maxGameObject.position.x) {
            maxGameObject = go;
        }
    }
    
    return maxGameObject;
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
    
    if (!([theEvent modifierFlags] & NSShiftKeyMask)) {
        [self unselectAllGameObjects];        
    }
    
    startSelection = YES;
    // Loop in reverse so that one closest to user is selected first
    for (int i = [gameObjects count] - 1; i >= 0; i--) {
        GameObject *gameObject = [gameObjects objectAtIndex:i];
        if ([gameObject isPointInImage:downPoint] 
            || [gameObject isPointInMoveHandle:downPoint]
            || [gameObject isPointInResizeHandle:downPoint]) {
            
            startSelection = NO;
            gameObject.selected = YES;
            if ([gameObject isPointInMoveHandle:downPoint]) {
                gameObject.moveHandleSelected = YES;
            }
            
            if ([gameObject isPointInResizeHandle:downPoint]) {
                gameObject.resizeHandleSelected = YES;
            }
            break;
        }
    }

    [self updateSelectedInfo];
    
//    NSLog(@"mouseDown: %f %f   imagepos: %f %f", downPoint.x, downPoint.y, image.position.x, image.position.y);


    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self autoscroll:theEvent];
    GameObject *gameObject = [self getMoveHandleSelectedGameObject];
    if (gameObject != nil) {
        CGFloat deltaX = currentPoint.x - downPoint.x;
        CGFloat deltaY = 0;
        if (!([theEvent modifierFlags] & NSShiftKeyMask)) {
            deltaY = currentPoint.y - downPoint.y;
        }
        
        gameObject.position = CGPointMake(gameObject.position.x + deltaX, gameObject.position.y + deltaY);
        downPoint = currentPoint;
        
        [self updateSelectedInfo];
    }
    
    gameObject = [self getResizeHandleSelectedGameObject];
    if (gameObject != nil) {
        //CGFloat deltaX = currentPoint.x - downPoint.x;
        CGFloat deltaY = currentPoint.y - downPoint.y;

        [gameObject setScalesWhenResized:YES];
        CGSize newSize = CGSizeMake([gameObject size].width, [gameObject size].height+deltaY);
        [gameObject setSize:newSize];

        downPoint = currentPoint;
        
        [self updateSelectedInfo];        
    }

    if (startSelection) {
        CGFloat w = currentPoint.x - downPoint.x;
        CGFloat h = (currentPoint.y - downPoint.y);
        //NSLog(@"down=(%f %f) cur=(%f %f) w=%f h=%f", downPoint.x, downPoint.y, currentPoint.x, currentPoint.y, w, h);
        selectionRect = CGRectMake(downPoint.x, downPoint.y, w, h);

        for (GameObject *go in gameObjects) {
            if ([go isRectIntersectImage:selectionRect]) {
                go.selected = YES;
            }
        }
    }
    
    [self setNeedsDisplay:YES];

}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    p = [self convertPoint:p fromView:nil];
    
    if (!([theEvent modifierFlags] & NSShiftKeyMask)) {
        if (!startSelection) {
            for (GameObject *gameObject in gameObjects) {
                if (![gameObject isPointInImage:p] && ![gameObject isPointInMoveHandle:p] && ![gameObject isPointInResizeHandle:p]) {
                    gameObject.selected = NO;
                    gameObject.moveHandleSelected = NO;
                    gameObject.resizeHandleSelected = NO;
                }
            }
        }
    }

    selectionRect = CGRectMake(0, 0, 0, 0);
    
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

- (void) moveSelectedGameObjectsByX:(int)xDelta andY:(int)yDelta {
    for (GameObject *go in gameObjects) {
        if (go.selected) {
            go.position = CGPointMake(go.position.x + xDelta, go.position.y + yDelta);
        }
    }
}

- (void) deleteSelectedGameObjects {
    for (int i = [gameObjects count] - 1; i >= 0; i--) {
        GameObject *go = [gameObjects objectAtIndex:i];
        if (go.selected) {
            [gameObjects removeObjectAtIndex:i];
        }
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    if ([theEvent modifierFlags] & NSShiftKeyMask) {
        switch ([theEvent keyCode]) {
            case 126:       // up arrow
                [self moveSelectedGameObjectsByX:0 andY:10];
                [self updateSelectedInfo];
                break;
            case 125:       // down arrow
                [self moveSelectedGameObjectsByX:0 andY:-10];
                [self updateSelectedInfo];
                break;
            case 124:       // right arrow
                [self moveSelectedGameObjectsByX:10 andY:0];
                [self updateSelectedInfo];
                break;
            case 123:       // left arrow
                [self moveSelectedGameObjectsByX:-10 andY:0];
                [self updateSelectedInfo];
                break;
            default:
                NSLog(@"Key pressed: %@", theEvent);
                break;
        }        
    }
    else if ([theEvent modifierFlags] & NSCommandKeyMask) {
        switch ([theEvent keyCode]) {
            case 0: // select all
                for (GameObject *go in gameObjects) {
                    go.selected = YES;
                }
                break;
        }
    }
    else {
        switch ([theEvent keyCode]) {
            case 126:       // up arrow
                [self moveSelectedGameObjectsByX:0 andY:1];
                [self updateSelectedInfo];
                break;
            case 125:       // down arrow
                [self moveSelectedGameObjectsByX:0 andY:-1];
                [self updateSelectedInfo];
                break;
            case 124:       // right arrow
                [self moveSelectedGameObjectsByX:1 andY:0];
                [self updateSelectedInfo];
                break;
            case 123:       // left arrow
                [self moveSelectedGameObjectsByX:-1 andY:0];
                [self updateSelectedInfo];
                break;
            case 51:        // delete key
                [self deleteSelectedGameObjects];
                break;
            default:
                NSLog(@"Key pressed: %@", theEvent);
                break;
        }
    //    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    }
    [self setNeedsDisplay:YES];
}

- (void)insertText:(NSString*)insertString {
    
}
 
#pragma mark Level serialization and loading
- (NSArray*) levelForSerialization {
    NSMutableArray *gameItems = [NSMutableArray array];
    for (GameObject *gameObject in gameObjects) {
        NSMutableDictionary *levelDict = [NSMutableDictionary dictionary];
        
        [gameObject levelForSerialization:levelDict];

        [gameItems addObject:levelDict];
    }
    
    NSArray *sortedGameItems = [gameItems sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSDictionary *item1 = (NSDictionary*) obj1;
        NSDictionary *item2 = (NSDictionary*) obj2;
        CGFloat x1 = [[item1 objectForKey:@"XPosition"] floatValue];
        CGFloat x2 = [[item2 objectForKey:@"XPosition"] floatValue];
        if (x1 > x2) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        if (x1 < x2) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        
        return (NSComparisonResult) NSOrderedSame;
    }];

    return sortedGameItems;
}



- (void) loadLevel:(NSArray*)levelItems {
    for (NSDictionary *level in levelItems) {        
        GameObject *gameObject = nil;

        NSString *type = [level objectForKey:@"Type"]; 
        gameObject = [GameObject instanceOf:type];
                
        [gameObject loadFromDict:level];
        [self addGameObject:gameObject isSelected:NO];
    }
    [self scrollPoint:CGPointMake(0, 0)];
        
    [self setNeedsDisplay:YES];
}

- (void) sortGameObjectsByZOrder {
    NSArray *sortedGameItems = [gameObjects sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        GameObject *item1 = (GameObject*) obj1;
        GameObject *item2 = (GameObject*) obj2;
        CGFloat x1 = item1.zOrder;
        CGFloat x2 = item2.zOrder;
        if (x1 > x2) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        if (x1 < x2) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        
        return (NSComparisonResult) NSOrderedSame;
    }];
    
    [gameObjects removeAllObjects];
    
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:sortedGameItems];
    gameObjects = sortedArray;    
}

- (void) clearCanvas {
    [gameObjects removeAllObjects];
    [self setNeedsDisplay:YES];
}

@end
