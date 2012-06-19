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

- (void) updateSelectedInfo {
    GameObject *gameObject = [self getSelectedGameObject];
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    [appDelegate.xPosition setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.position.x]];
    [appDelegate.yPosition setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.position.y]];
    
    [appDelegate.period setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.period]];
    [appDelegate.ropeLength setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.ropeLength]];
    [appDelegate.poleScale setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.poleScale]];
    [appDelegate.swingAngle setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.swingAngle]];
    [appDelegate.grip setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.grip]];
    [appDelegate.windSpeed setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.windSpeed]];
    [appDelegate.windDirection setStringValue:gameObject == nil || gameObject.windDirection == nil ? @"" : gameObject.windDirection];
    [appDelegate.cannonSpeed setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.cannonSpeed]];
    [appDelegate.cannonForce setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.cannonForce]];
    [appDelegate.cannonRotationAngle setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.cannonRotationAngle]];
    [appDelegate.zOrder setIntValue:gameObject.zOrder];
    [appDelegate.zOrderStepper setIntValue:gameObject.zOrder];
}

- (void) updateSelectedCannonSpeed:(CGFloat)speed {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.cannonSpeed = speed;    
}

- (void) updateSelectedZOrder:(int)zOrder {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.zOrder = zOrder;   
    
    [self sortGameObjectsByZOrder];
    [self setNeedsDisplay:YES];
}

- (void) updateSelectedCannonForce:(CGFloat)force {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.cannonForce = force;    
}

- (void) updateSelectedCannonRotationAngle:(CGFloat)angle {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.cannonRotationAngle = angle;    
    [self setNeedsDisplay:YES];    
}

- (void) updateSelectedPeriod:(CGFloat)newSwingSpeed {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.period = newSwingSpeed;
}

- (void) updateSelectedPosition:(CGPoint)newPos {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.position = newPos;
    [self setNeedsDisplay:YES];
}

- (void) updateSelectedRopeLength:(CGFloat)ropeLength {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.ropeLength = ropeLength;
    [self setNeedsDisplay:YES];    
}

- (void) unselectAllGameObjects {
    for (GameObject *gameObject in gameObjects) {
        gameObject.selected = NO;
        gameObject.moveHandleSelected = NO;
        gameObject.resizeHandleSelected = NO;
    }    
}

- (void) updateSelectedSwingAngle:(CGFloat)swingAngle {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.swingAngle = swingAngle;
    [self setNeedsDisplay:YES];        
}

- (void) updateSelectedPoleScale:(CGFloat)poleScale {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.poleScale = poleScale;
    [self setNeedsDisplay:YES];        
}

- (void) updateSelectedGrip:(CGFloat)grip {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.grip = grip;
}

- (void) updateSelectedWindSpeed:(CGFloat)windSpeed {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.windSpeed = windSpeed;
}

- (void) updateSelectedWindDirection:(NSString*)windDirection {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.windDirection = windDirection;
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
        switch (gameObject.gameObjectType) {
            case kGameObjectTypeSwinger:
                [levelDict setObject:@"Catcher" forKey:@"Type"];
                break;
            case kGameObjectTypeCannon:
                [levelDict setObject:@"Cannon" forKey:@"Type"];
                break;                
            case kGameObjectTypeFinalPlatform:
                [levelDict setObject:@"FinalPlatform" forKey:@"Type"];
                break;                
            case kGameObjectTypeDummy:
                [levelDict setObject:@"Dummy" forKey:@"Type"];
                break;                                
            case kGameObjectTypeStar:
                [levelDict setObject:@"Star" forKey:@"Type"];
                break;                                
            case kGameObjectTypeCoin:
                [levelDict setObject:@"Coin" forKey:@"Type"];
                break;
            // From here on out, these are foreground parallax layer objects.
            // Store the file name of the image directly as the Type
            case kGameObjectTypeTreeClump1:
                [levelDict setObject:@"L1aTreeClump1.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeTreeClump2:
                [levelDict setObject:@"L1aTreeClump2.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeTreeClump3:
                [levelDict setObject:@"L1aTreeClump3.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeTent1:
                [levelDict setObject:@"L1a_Tent1.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeTent2:
                [levelDict setObject:@"L1a_Tent2.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeBalloonCart:
                [levelDict setObject:@"L1a_BalloonCart.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypePopcornCart:
                [levelDict setObject:@"L1a_PopcornCart.png" forKey:@"Type"];
                break;                                
            case kGameObjectTypeBoxes:
                [levelDict setObject:@"L1a_Boxes1.png" forKey:@"Type"];
                break;                                
            default:
                break;
        }
        
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject position].x/2] forKey:@"XPosition"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject position].y/2] forKey:@"YPosition"];
        [levelDict setObject:[NSNumber numberWithInt:gameObject.zOrder] forKey:@"Z-Order"];
        
        if (gameObject.gameObjectType != kGameObjectTypeStar
            && gameObject.gameObjectType != kGameObjectTypeTreeClump1
            && gameObject.gameObjectType != kGameObjectTypeTreeClump2
            && gameObject.gameObjectType != kGameObjectTypeTreeClump3
            && gameObject.gameObjectType != kGameObjectTypeTent1
            && gameObject.gameObjectType != kGameObjectTypeTent2
            && gameObject.gameObjectType != kGameObjectTypeBalloonCart
            && gameObject.gameObjectType != kGameObjectTypePopcornCart
            && gameObject.gameObjectType != kGameObjectTypeBoxes
            && gameObject.gameObjectType != kGameObjectTypeCoin) {
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject period]] forKey:@"Period"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject ropeLength]] forKey:@"RopeLength"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject grip]] forKey:@"Grip"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject swingAngle]] forKey:@"SwingAngle"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject poleScale]] forKey:@"PoleScale"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject windSpeed]] forKey:@"WindSpeed"];
            [levelDict setObject:[gameObject windDirection] == nil ? @"" : [gameObject windDirection] forKey:@"WindDirection"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject cannonSpeed]] forKey:@"Speed"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject cannonForce]] forKey:@"Force"];
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject cannonRotationAngle]] forKey:@"RotationAngle"];
        }
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
        if ([@"Catcher" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SwingPole1" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeSwinger;
        } else if ([@"Cannon" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cannon" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0, 0)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeCannon;
        } else if ([@"FinalPlatform" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"finalPlatform" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0, 0)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeFinalPlatform;
        } else if ([@"Dummy" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dummy" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0, 0)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeDummy;            
        } else if ([@"Star" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeStar;
        } else if ([@"Coin" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Coin1" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeCoin;
        }
        // From here on out, these are foreground parallax layer objects.
        // Check if the type is the file name of the image.
        else if ([@"L1aTreeClump1.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1aTreeClump1" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeTreeClump1;
        } else if ([@"L1aTreeClump2.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1aTreeClump2" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeTreeClump2;
        } else if ([@"L1aTreeClump3.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1aTreeClump3" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeTreeClump3;
        } else if ([@"L1a_Tent1.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1a_Tent1" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeTent1;
        } else if ([@"L1a_Tent2.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1a_Tent2" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeTent2;
        } else if ([@"L1a_BalloonCart.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1a_BalloonCart" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeBalloonCart;
        } else if ([@"L1a_PopcornCart.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1a_PopcornCart" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypePopcornCart;
        } else if ([@"L1a_Boxes1.png" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"L1a_Boxes1" ofType:@"png"]
                                                        anchorPoint:CGPointMake(0.5, 0.5)
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeBoxes;
        }
        
        
        if (gameObject != nil) {
            gameObject.position = CGPointMake([[level objectForKey:@"XPosition"] floatValue]*2,
                                              [[level objectForKey:@"YPosition"] floatValue]*2);

            gameObject.zOrder = [[level objectForKey:@"Z-Order"] intValue];
            
            if (gameObject.gameObjectType != kGameObjectTypeStar
                && gameObject.gameObjectType != kGameObjectTypeTreeClump1
                && gameObject.gameObjectType != kGameObjectTypeTreeClump2
                && gameObject.gameObjectType != kGameObjectTypeTreeClump3
                && gameObject.gameObjectType != kGameObjectTypeTent1
                && gameObject.gameObjectType != kGameObjectTypeTent2
                && gameObject.gameObjectType != kGameObjectTypePopcornCart
                && gameObject.gameObjectType != kGameObjectTypeBalloonCart
                && gameObject.gameObjectType != kGameObjectTypeBoxes
                && gameObject.gameObjectType != kGameObjectTypeCoin) 
            {
                gameObject.period = [[level objectForKey:@"Period"] floatValue];
                gameObject.ropeLength = [[level objectForKey:@"RopeLength"] floatValue];
                gameObject.grip = [[level objectForKey:@"Grip"] floatValue];
                gameObject.swingAngle = [[level objectForKey:@"SwingAngle"] floatValue];
                gameObject.poleScale = [[level objectForKey:@"PoleScale"] floatValue];
                gameObject.windSpeed = [[level objectForKey:@"WindSpeed"] floatValue];
                gameObject.windDirection = [level objectForKey:@"WindDirection"];
                gameObject.cannonForce = [[level objectForKey:@"Force"] floatValue];
                gameObject.cannonRotationAngle = [[level objectForKey:@"RotationAngle"] floatValue];
                gameObject.cannonSpeed = [[level objectForKey:@"Speed"] floatValue];
            }
            
            [self addGameObject:gameObject isSelected:NO];
        }
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
