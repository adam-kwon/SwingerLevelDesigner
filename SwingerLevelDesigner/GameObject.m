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
#import "Notifications.h"
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
#import "FloatingPlatform.h"
#import "FireRing.h"
#import "Magnet.h"
#import "Hunter.h"
#import "AngerPotion.h"
#import "SpeedBoost.h"
#import "JetPack.h"
#import "MissileLauncher.h"
#import "Saw.h"
#import "Block.h"
#import "Insect.h"
#import "OilBarrel.h"

#define INIT_INSTANCE(obj, objectName, anchorX, anchorY)    if (obj == nil) { \
                                                                obj = [[objectName alloc] initWithAnchorPoint:CGPointMake(anchorX, anchorY)]; \
                                                                go = obj; \
                                                            } \
                                                            else { \
                                                                go = [obj copy]; \
                                                            }

#define INIT_INSTANCE_TYPE(obj, objectName, anchorX, anchorY, type) if (obj == nil) { \
                                                                        obj = [[objectName alloc] initWithAnchorPoint:CGPointMake(anchorX, anchorY) ofType:type]; \
                                                                        go = obj; \
                                                                    } \
                                                                    else { \
                                                                        go = [obj copy]; \
                                                                    }


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
@synthesize scaleY;
@synthesize scaleX;

static GameObject *pole;
static GameObject *cannon;
static GameObject *spring;
static GameObject *elephant;
static GameObject *finalPlatform;
static GameObject *treeClump1;
static GameObject *treeClump2;
static GameObject *treeClump3;
static GameObject *tent1;
static GameObject *tent2;
static GameObject *dummy;
static GameObject *balloonCart;
static GameObject *popcornCart;
static GameObject *coin;
static GameObject *star;
static GameObject *boxes;
static GameObject *wheel;
static GameObject *strongMan;
static GameObject *forestRetreatTreeClump1;
static GameObject *forestRetreatTreeClump2;
static GameObject *forestRetreatTreeClump3;
static GameObject *forestRetreatTree1;
static GameObject *forestRetreatTree2;
static GameObject *forestRetreatTree3;
static GameObject *forestRetreatTree4;
static GameObject *torch;
static GameObject *floatingPlatform;
static GameObject *fireRing;
static GameObject *magnet;
static GameObject *hunter;
static GameObject *angerPotion;
static GameObject *speedBoost;
static GameObject *jetPack;
static GameObject *missile;
static GameObject *saw;
static GameObject *block;
static GameObject *insect;
static GameObject *oilBarrel;

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
    self.scaleY = 1.0;
    self.scaleX = 1.0;
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
        INIT_INSTANCE(pole, Pole, 0.5, 0.0)
    }
    else if ([@"Cannon" isEqualToString:type]) {
        INIT_INSTANCE(cannon, Cannon, 0.5, 0.0)
    }
    else if ([@"Spring" isEqualToString:type]) {
        INIT_INSTANCE(spring, Spring, 0.5, 0.0)
    }
    else if ([@"Elephant" isEqualToString:type]) {
        INIT_INSTANCE(elephant, Elephant, 0.5, 0.5)
    }
    else if ([@"FinalPlatform" isEqualToString:type] || [@"Final Platform" isEqualToString:type]) {
        INIT_INSTANCE(finalPlatform, FinalPlatform, 0.0, 0.0)
    }
    else if ([@"Tree Clump 1" isEqualToString:type] || [@"L1aTreeClump1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(treeClump1, TreeClump, 0.5, 0.5, kTreeClump1);
    }
    else if ([@"Tree Clump 2" isEqualToString:type] || [@"L1aTreeClump2.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(treeClump2, TreeClump, 0.5, 0.5, kTreeClump2);
    }
    else if ([@"Tree Clump 3" isEqualToString:type] || [@"L1aTreeClump3.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(treeClump3, TreeClump, 0.5, 0.5, kTreeClump3);
    }
    else if ([@"Tent 1" isEqualToString:type] || [@"L1a_Tent1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(tent1, Tent, 0.5, 0.5, kTent1);
    }
    else if ([@"Tent 2" isEqualToString:type] || [@"L1a_Tent2.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(tent2, Tent, 0.5, 0.5, kTent2);
    }
    else if ([@"Dummy" isEqualToString:type]) {
        INIT_INSTANCE(dummy, Dummy, 0.5, 0.5)
    }
    else if ([@"Balloon Cart" isEqualToString:type] || [@"L1a_BalloonCart.png" isEqualToString:type]) {
        INIT_INSTANCE(balloonCart, BalloonCart, 0.5, 0.5)
    }
    else if ([@"Popcorn Cart" isEqualToString:type] || [@"L1a_PopcornCart.png" isEqualToString:type]) {
        INIT_INSTANCE(popcornCart, PopcornCart, 0.5, 0.5)
    }
    else if ([@"Coin" isEqualToString:type]) {
        INIT_INSTANCE(coin, Coin, 0.5, 0.5)
    }
    else if ([@"Star" isEqualToString:type]) {
        INIT_INSTANCE(star, Star, 0.5, 0.5)
    }
    else if ([@"Boxes" isEqualToString:type] || [@"L1a_Boxes1.png" isEqualToString:type]) {
        INIT_INSTANCE(boxes, Boxes, 0.5, 0.5)
    }
    else if ([@"Wheel" isEqualToString:type]) {
        INIT_INSTANCE(wheel, Wheel, 0.5, 0.5)
    }
    else if ([@"StrongMan" isEqualToString:type] || [@"Strong Man" isEqualToString:type]) {
        INIT_INSTANCE(strongMan, StrongMan, 0.5, 0.f)
    }
    else if ([@"Forest Retreat Tree Clump 1" isEqualToString:type] || [@"L2a_TreeClump1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTreeClump1, TreeClump, 0.5, 0.5, kTreeClump1ForestRetreat);
    }
    else if ([@"Forest Retreat Tree Clump 2" isEqualToString:type] || [@"L2a_TreeClump2.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTreeClump2, TreeClump, 0.5, 0.5, kTreeClump2ForestRetreat);
    }
    else if ([@"Forest Retreat Tree Clump 3" isEqualToString:type] || [@"L2a_TreeClump3.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTreeClump3, TreeClump, 0.5, 0.5, kTreeClump3ForestRetreat);
    }
    else if ([@"Forest Retreat Tree 1" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTree1, TreeClump, 0.5, 0.5, kTree1ForestRetreat);
    }
    else if ([@"Forest Retreat Tree 2" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTree2, TreeClump, 0.5, 0.5, kTree2ForestRetreat);
    }
    else if ([@"Forest Retreat Tree 3" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTree3, TreeClump, 0.5, 0.5, kTree3ForestRetreat);
    }
    else if ([@"Forest Retreat Tree 4" isEqualToString:type] || [@"L2a_Tree1.png" isEqualToString:type]) {
        INIT_INSTANCE_TYPE(forestRetreatTree4, TreeClump, 0.5, 0.5, kTree4ForestRetreat);
    }
    else if ([@"Torch" isEqualToString:type] || [@"L2a_Torch.png" isEqualToString:type]) {
        INIT_INSTANCE(torch, Torch, 0.5, 0.5)
    }
    else if ([@"FloatingPlatform" isEqualToString:type] || [@"Floating Platform" isEqualToString:type]) {
        INIT_INSTANCE(floatingPlatform, FloatingPlatform, 0.0, 0.5)
    }
    else if ([@"FireRing" isEqualToString:type] || [@"Fire Ring" isEqualToString:type]) {
        INIT_INSTANCE(fireRing, FireRing, 0.5, 0.5)
    }
    else if ([@"Magnet" isEqualToString:type]) {
        INIT_INSTANCE(magnet, Magnet, 0.5, 0.5)
    }
    else if ([@"Hunter" isEqualToString:type]) {
        INIT_INSTANCE(hunter, Hunter, 0.5, 0.5)
    }
    else if ([@"AngerPotion" isEqualToString:type] || [@"Anger Potion" isEqualToString:type]) {
        INIT_INSTANCE(angerPotion, AngerPotion, 0.5, 0.5)
    }
    else if ([@"SpeedBoost" isEqualToString:type] || [@"Speed Boost" isEqualToString:type]) {
        INIT_INSTANCE(speedBoost, SpeedBoost, 0.5, 0.5)
    }
    else if ([@"JetPack" isEqualToString:type] || [@"Jet Pack" isEqualToString:type]) {
        INIT_INSTANCE(jetPack, JetPack, 0.5, 0.5)
    }
    else if ([@"MissileLauncher" isEqualToString:type] || [@"Missile Launcher" isEqualToString:type]) {
        INIT_INSTANCE(missile, MissileLauncher, 0.5, 0.5)
    }
    else if ([@"Saw" isEqualToString:type]) {
        INIT_INSTANCE(saw, Saw, 0.5, 0.5)
    }
    else if ([@"Block" isEqualToString:type]) {
        INIT_INSTANCE(block, Block, 0.5, 0.5)
    }
    else if ([@"Insect" isEqualToString:type]) {
        INIT_INSTANCE(insect, Insect, 0.5, 0.5);
    }
    else if ([@"Barrel" isEqualToString:type] || [@"Oil Barrel" isEqualToString:type]) {
        INIT_INSTANCE(oilBarrel, OilBarrel, 0.5, 0.5);
    }
    
    return go;
}

- (void) levelForSerialization:(NSMutableDictionary*)levelDict {
    [levelDict setObject:[self gameObjectTypeString] forKey:@"Type"];
    
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.position.x/2] forKey:@"XPosition"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.position.y/2] forKey:@"YPosition"];
    [levelDict setObject:[NSString stringWithFormat:@"%d", self.zOrder] forKey:@"Z-Order"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.scaleY] forKey:@"PoleScale"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.grip] forKey:@"Grip"];
    [levelDict setObject:[NSString stringWithFormat:@"%.2f", self.windSpeed] forKey:@"WindSpeed"];
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
    CGSize newSize = CGSizeMake(originalSize.width*scaleX, originalSize.height*scaleY);
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
        
        [appDelegate.poleScale setStringValue:[NSString stringWithFormat:@"%.2f", self.scaleY]];
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
        self.scaleY = [appDelegate.poleScale floatValue];
        
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
    scaleY = aSize.height / originalSize.height;
    scaleX = aSize.width / originalSize.width;
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
