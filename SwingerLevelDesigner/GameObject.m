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
#import "Pole.h"
#import "Cannon.h"
#import "Spring.h"
#import "Elephant.h"
#import "FinalPlatform.h"
#import "TreeClump.h"
#import "Tent.h"
#import "Dummy.h"
#import "BalloonCart.h"
#import "PopcornCart.h"
#import "Star.h"
#import "Coin.h"
#import "Boxes.h"
#import "Wheel.h"
#import "StrongMan.h"
#import "Torch.h"
#import "Notifications.h"

@implementation GameObject

@synthesize position;
@synthesize selected;
@synthesize gameObjectType;
@synthesize moveHandleSelected;
@synthesize resizeHandleSelected;
@synthesize grip;
@synthesize windSpeed;
@synthesize windDirection;
@synthesize anchorYOffset;
@synthesize anchorXOffset;
@synthesize zOrder;
@synthesize anchorPoint;
@synthesize name;
@synthesize scale;

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

- (id) initWithAnchorPoint:(CGPoint)ap {
    NSAssert(NO, @"Must be overriden");
    return nil;
}

- (id) initWithContentsOfFile:(NSString *)fileName anchorPoint:(CGPoint)ap {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    self = [super initWithContentsOfFile:fullPath];
    self.windDirection = @"";
    self.scale = 1.0;
    self.grip = 20.0;
    self.zOrder = 0;
    self.anchorPoint = ap;
    moveHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-move-hi" 
                                                                                         ofType:@"png"]];
    
    resizeHandle = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn-scale-hi" 
                                                                                           ofType:@"png"]];
    originalSize = [self size];
    
    anchorXOffset = [self size].width * anchorPoint.x;
    anchorYOffset = [self size].height * anchorPoint.y;


    
//    lbl = [[NSTextView alloc] initWithFrame:CGRectMake(0, 40, 400, 60)];
//    [lbl setString:@""];
//    [lbl setDrawsBackground:NO];
//    [lbl setSelectable:NO];
//    [lbl setEditable:NO];
//    [lbl setFont:[NSFont fontWithName:@"Courier New" size:11]];
//    [parent addSubview:lbl];
    
    return self;
}

+ (id) instanceOf:(NSString*)type {
    GameObject *go = nil;
    
    if ([@"Pole" isEqualToString:type] || [@"Catcher" isEqualToString:type]) {
        go = [[Pole alloc] initWithAnchorPoint:CGPointMake(0.0, 0.0)];
    }
    else if ([@"Cannon" isEqualToString:type]) {
        go = [[Cannon alloc] initWithAnchorPoint:CGPointMake(0.0, 0.0)];        
    }
    else if ([@"Spring" isEqualToString:type]) {
        go = [[Spring alloc] initWithAnchorPoint:CGPointMake(0.5, 0.0)];        
    }
    else if ([@"Elephant" isEqualToString:type]) {
        go = [[Elephant alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"FinalPlatform" isEqualToString:type] || [@"Final Platform" isEqualToString:type]) {
        go = [[FinalPlatform alloc] initWithAnchorPoint:CGPointMake(0.0, 0.0)];        
    }
    else if ([@"Tree Clump 1" isEqualToString:type] || [@"L1aTreeClump1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump1];        
    }
    else if ([@"Tree Clump 2" isEqualToString:type] || [@"L1aTreeClump2.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump2];        
    }
    else if ([@"Tree Clump 3" isEqualToString:type] || [@"L1aTreeClump3.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump3];        
    }
    else if ([@"Tent 1" isEqualToString:type] || [@"L1a_Tent1.png" isEqualToString:type]) {
        go = [[Tent alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTent1];        
    }
    else if ([@"Tent 2" isEqualToString:type] || [@"L1a_Tent2.png" isEqualToString:type]) {
        go = [[Tent alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTent2];        
    }
    else if ([@"Dummy" isEqualToString:type]) {
        go = [[Dummy alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Balloon Cart" isEqualToString:type] || [@"L1a_BalloonCart.png" isEqualToString:type]) {
        go = [[BalloonCart alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Popcorn Cart" isEqualToString:type] || [@"L1a_PopcornCart.png" isEqualToString:type]) {
        go = [[PopcornCart alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Coin" isEqualToString:type]) {
        go = [[Coin alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Star" isEqualToString:type]) {
        go = [[Star alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Boxes" isEqualToString:type] || [@"L1a_Boxes1.png" isEqualToString:type]) {
        go = [[Boxes alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }
    else if ([@"Wheel" isEqualToString:type]) {
        go = [[Wheel alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];
    }
    else if ([@"StrongMan" isEqualToString:type] || [@"Strong Man" isEqualToString:type]) {
        go = [[StrongMan alloc] initWithAnchorPoint:CGPointMake(0.5, 0.0)];
    }
    else if ([@"Forest Retreat Tree Clump 1" isEqualToString:type] || [@"L2a_TreeClump1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump1ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree Clump 2" isEqualToString:type] || [@"L2a_TreeClump2.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump2ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree Clump 3" isEqualToString:type] || [@"L2a_TreeClump3.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTreeClump3ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree 1" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTree1ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree 2" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTree2ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree 3" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTree3ForestRetreat];        
    }
    else if ([@"Forest Retreat Tree 4" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        go = [[TreeClump alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5) ofType:kTree4ForestRetreat];        
    }
    else if ([@"Torch" isEqualToString:type] || [@"L2a_Torch.png" isEqualToString:type]) {
        go = [[Torch alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];        
    }

    
    return go;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [levelDict setObject:[self gameObjectTypeString] forKey:@"Type"];
    [levelDict setObject:[NSNumber numberWithFloat:self.position.x/2] forKey:@"XPosition"];
    [levelDict setObject:[NSNumber numberWithFloat:self.position.y/2] forKey:@"YPosition"];
    [levelDict setObject:[NSNumber numberWithInt:self.zOrder] forKey:@"Z-Order"];
    [levelDict setObject:[NSNumber numberWithFloat:self.scale] forKey:@"PoleScale"];
    [levelDict setObject:[NSNumber numberWithFloat:self.grip] forKey:@"Grip"];
    [levelDict setObject:[NSNumber numberWithFloat:self.windSpeed] forKey:@"WindSpeed"];
    [levelDict setObject:self.windDirection == nil ? @"" : self.windDirection forKey:@"WindDirection"];
}

- (void) loadFromDict:(NSDictionary*)level {
    self.position = CGPointMake([[level objectForKey:@"XPosition"] floatValue]*2,
                                [[level objectForKey:@"YPosition"] floatValue]*2);
    
    self.zOrder = [[level objectForKey:@"Z-Order"] intValue];
    self.grip = [[level objectForKey:@"Grip"] floatValue];
    self.windSpeed = [[level objectForKey:@"WindSpeed"] floatValue];
    self.windDirection = [level objectForKey:@"WindDirection"];

}

- (CGPoint) getWindForce:(float)mass {
    CGPoint impVec = CGPointZero;
    float impulse = self.windSpeed * mass;
    
    if ([@"N" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(0, impulse);
    }
    else if ([@"S" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(0, -impulse);
    }
    else if ([@"E" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(impulse, 0);
    }
    else if ([@"W" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(-impulse, 0);
    }
    else if ([@"NE" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(impulse, impulse);
    }
    else if ([@"NW" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(-impulse, impulse);
    }
    else if ([@"SE" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(impulse, -impulse);
    }
    else if ([@"SW" isEqualToString:self.windDirection]) {
        impVec = CGPointMake(-impulse, -impulse);
    }
    return impVec;
}

// Origin is lower, left
- (void) draw:(CGContextRef)ctx {
    
    [self setScalesWhenResized:YES];
    CGSize newSize = CGSizeMake(originalSize.width, originalSize.height*scale);
    [self setSize:newSize];
    
    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = [self size];
    [self drawAtPoint:CGPointMake(position.x - anchorXOffset, position.y - anchorYOffset) 
             fromRect:imageRect 
            operation:NSCompositeSourceOver 
             fraction:1.0];        
    
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
    
//    if (gameObjectType == kGameObjectTypeSwinger) {
//        NSString *str;
//        
//        str = [NSString stringWithFormat:@"%15s %.2f secs\n%15s %.2f\n%15s %.2f\n%15s %@", 
//                         "Period:", "Grip:", "Wind speed:", "Wind direction:", period, grip, windSpeed, windDirection];
//        
//        [lbl setString:str];
//        [lbl setFrameOrigin:CGPointMake(position.x + [self size].width, position.y)];
//    } else {
//        if (lbl != nil) {
//            [lbl removeFromSuperview];
//            lbl = nil;
//        }
//    }
}

- (void) updateInfo {
    if (selected) {
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        [appDelegate.xPosition setStringValue:[NSString stringWithFormat:@"%.2f", self.position.x]];
        [appDelegate.yPosition setStringValue:[NSString stringWithFormat:@"%.2f", self.position.y]];
        
        [appDelegate.poleScale setStringValue:[NSString stringWithFormat:@"%.2f", self.scale]];
        [appDelegate.grip setStringValue:[NSString stringWithFormat:@"%.2f", self.grip]];
        [appDelegate.windSpeed setStringValue:[NSString stringWithFormat:@"%.2f", self.windSpeed]];
        [appDelegate.windDirection setStringValue:self.windDirection == nil ? @"" : self.windDirection];
        [appDelegate.zOrder setIntValue:self.zOrder];
        [appDelegate.zOrderStepper setIntValue:self.zOrder];
    }
}

- (void) updateProperties {
    if (selected) {
        AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
        self.position = CGPointMake([appDelegate.xPosition floatValue], [appDelegate.yPosition floatValue]);
        self.scale = [appDelegate.poleScale floatValue];
        self.grip = [appDelegate.grip floatValue];
        self.windSpeed = [appDelegate.windSpeed floatValue];
        self.windDirection = [appDelegate.windDirection stringValue];
        if ([appDelegate.zOrder intValue] != self.zOrder) {
            self.zOrder = [appDelegate.zOrder intValue];        
            [[NSNotificationCenter defaultCenter] postNotificationName:Z_ORDER_CHANGED object:nil];
        }
    }
}

- (void) setGameObjectType:(GameObjectType)type {
    gameObjectType = type;
}

- (void) setSize:(NSSize)aSize {
    [super setSize:aSize];
    scale = aSize.height / originalSize.height;
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

- (NSString*) gameObjectTypeString {
    NSAssert(NO, @"Must be overriden");
    return nil;
}

- (void) dealloc {
    //[lbl removeFromSuperview];
}
@end
