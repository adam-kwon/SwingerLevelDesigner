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
    scale += 0.05;

    NSSize s = [self convertSize:NSMakeSize(1,1) fromView:nil];
    [self scaleUnitSquareToSize:s];    

    [self scaleUnitSquareToSize:CGSizeMake(scale, scale)];
    [self setNeedsDisplay:YES];
}
- (IBAction)zoomOut:(id)sender {
    scale -= 0.05;
    
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
        CGFloat deltaY = currentPoint.y - downPoint.y;
        
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
 
#pragma mark Level serialization and loading
- (NSArray*) levelForSerialization {
    NSMutableArray *gameItems = [NSMutableArray array];
    for (GameObject *gameObject in gameObjects) {
        NSMutableDictionary *levelDict = [NSMutableDictionary dictionary];
        if (gameObject.gameObjectType == kGameObjectTypeSwinger) {
            [levelDict setObject:@"Catcher" forKey:@"Type"];
        }
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject position].x / deviceScreenWidth] forKey:@"Position"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject period]] forKey:@"Period"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject ropeLength]] forKey:@"RopeLength"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject grip]] forKey:@"Grip"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject swingAngle]] forKey:@"SwingAngle"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject poleScale]] forKey:@"PoleScale"];
        [levelDict setObject:[NSNumber numberWithFloat:[gameObject windSpeed]] forKey:@"WindSpeed"];
        [levelDict setObject:[gameObject windDirection] forKey:@"WindDirection"];
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
        CGFloat position = [[level objectForKey:@"Position"] floatValue];
        CGFloat period = [[level objectForKey:@"Period"] floatValue]; 
        CGFloat grip = [[level objectForKey:@"Grip"] floatValue]; 
        CGFloat swingAngle = [[level objectForKey:@"SwingAngle"] floatValue]; 
        CGFloat poleScale = [[level objectForKey:@"PoleScale"] floatValue]; 
        CGFloat windSpeed = [[level objectForKey:@"WindSpeed"] floatValue]; 
        CGFloat ropeLength = [[level objectForKey:@"RopeLength"] floatValue]; 
        NSString *windDirection = [level objectForKey:@"WindDirection"]; 
        NSString *type = [level objectForKey:@"Type"]; 
        
        GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SwingPole1" ofType:@"png"]];
        if ([@"Catcher" isEqualToString:type]) {
            gameObject.gameObjectType = kGameObjectTypeSwinger;
        }
        gameObject.period = period;
        gameObject.position = CGPointMake(position*deviceScreenWidth, 0);
        gameObject.ropeLength = ropeLength;
        gameObject.grip = grip;
        gameObject.swingAngle = swingAngle;
        gameObject.poleScale = poleScale;
        gameObject.windSpeed = windSpeed;
        gameObject.windDirection = windDirection;
        
        [self addGameObject:gameObject isSelected:NO];
    }
    [self setNeedsDisplay:YES];
}

- (void) clearCanvas {
    [gameObjects removeAllObjects];
    [self setNeedsDisplay:YES];
}

@end
