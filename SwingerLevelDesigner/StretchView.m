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
    
    [appDelegate.position setStringValue:[NSString stringWithFormat:@"%.2f", gameObject.position.x / deviceScreenWidth]];
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

}

- (void) updateSelectedCannonSpeed:(CGFloat)speed {
    GameObject *gameObject = [self getSelectedGameObject];
    gameObject.cannonSpeed = speed;    
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

    [self unselectAllGameObjects];
    
    for (GameObject *gameObject in gameObjects) {
        if ([gameObject isPointInImage:downPoint] 
            || [gameObject isPointInMoveHandle:downPoint]
            || [gameObject isPointInResizeHandle:downPoint]) {
            
            gameObject.selected = YES;
            if ([gameObject isPointInMoveHandle:downPoint]) {
                gameObject.moveHandleSelected = YES;
            }
            
            if ([gameObject isPointInResizeHandle:downPoint]) {
                gameObject.resizeHandleSelected = YES;
            }
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
    [self setNeedsDisplay:YES];
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
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint p = [theEvent locationInWindow];
    p = [self convertPoint:p fromView:nil];
    
    for (GameObject *gameObject in gameObjects) {
        if (![gameObject isPointInImage:p] && ![gameObject isPointInMoveHandle:p] && ![gameObject isPointInResizeHandle:p]) {
            gameObject.selected = NO;
            gameObject.moveHandleSelected = NO;
            gameObject.resizeHandleSelected = NO;
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
    if ([theEvent modifierFlags] & NSShiftKeyMask) {
        switch ([theEvent keyCode]) {
            case 126:       // up arrow
                gameObject.position = CGPointMake(gameObject.position.x, gameObject.position.y + 10);
                [self updateSelectedInfo];
                break;
            case 125:       // down arrow
                gameObject.position = CGPointMake(gameObject.position.x, gameObject.position.y - 10);
                [self updateSelectedInfo];
                break;
            case 124:       // right arrow
                gameObject.position = CGPointMake(gameObject.position.x + 10, gameObject.position.y);
                [self updateSelectedInfo];
                break;
            case 123:       // left arrow
                gameObject.position = CGPointMake(gameObject.position.x - 10, gameObject.position.y);
                [self updateSelectedInfo];
                break;
            default:
                NSLog(@"Key pressed: %@", theEvent);
                break;
        }        
    } else {
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
    //    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    }
    [self setNeedsDisplay:YES];
}

- (void)insertText:(NSString*)insertString {
    
}
 
#pragma mark Level serialization and loading
- (NSArray*) levelForSerialization {
    BOOL addCatcherProperties = YES;
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
                [levelDict setObject:[NSNumber numberWithFloat:[gameObject position].x / deviceScreenWidth] forKey:@"Position"];
                addCatcherProperties = NO;
                break;                                
            default:
                break;
        }
        if (addCatcherProperties) {
            [levelDict setObject:[NSNumber numberWithFloat:[gameObject position].x / deviceScreenWidth] forKey:@"Position"];
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
        CGFloat x1 = [[item1 objectForKey:@"Position"] floatValue];
        CGFloat x2 = [[item2 objectForKey:@"Position"] floatValue];
        NSLog(@"comparing values = %f %f", x1, x2);
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
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeSwinger;
        } else if ([@"Cannon" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cannon" ofType:@"png"]
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeCannon;
        } else if ([@"FinalPlatform" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"finalPlatform" ofType:@"png"]
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeFinalPlatform;
        } else if ([@"Dummy" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dummy" ofType:@"png"]
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeDummy;            
        } else if ([@"Star" isEqualToString:type]) {
            gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"]
                                                             parent:self];
            gameObject.gameObjectType = kGameObjectTypeStar;
        }
        
        if (gameObject != nil) {
            gameObject.position = CGPointMake([[level objectForKey:@"Position"] floatValue]*deviceScreenWidth, 0);

            if (gameObject.gameObjectType != kGameObjectTypeStar) {
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

- (void) clearCanvas {
    [gameObjects removeAllObjects];
    [self setNeedsDisplay:YES];
}

@end
