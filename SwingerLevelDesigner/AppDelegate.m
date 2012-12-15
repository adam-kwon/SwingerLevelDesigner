//
//  AppDelegate.m
//  SwingerLevelDesigner
//
//  Created by Min Kwon on 5/24/12.
//  Copyright (c) 2012 GAMEPEONS, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "StretchView.h"
#import "GameObject.h"
#import "SetCanvasSizeWindowController.h"
#import "Pole.h"
#import "Notifications.h"
#import "GPUtil.h"
#import "Constants.h"
#import "Cannon.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize xPosition;
@synthesize yPosition;
@synthesize gameWorldSize;
@synthesize period;
@synthesize levelStepper;
@synthesize levelField;
@synthesize maxLevelField;
@synthesize ropeLength;
@synthesize windDirection;
@synthesize windSpeed;
@synthesize swingAngle;
@synthesize grip;
@synthesize poleScale;
@synthesize stretchView;
@synthesize cannonForce;
@synthesize cannonRotationAngle;
@synthesize cannonSpeed;
@synthesize zOrderStepper;
@synthesize zOrder;
@synthesize gameObjects;
@synthesize bounce;
@synthesize walkDistance;
@synthesize walkVelocity;
@synthesize wheelSpeed;
@synthesize worldNames;
@synthesize moveX;
@synthesize moveY;
@synthesize frequency;
@synthesize numCopies;
@synthesize numCopiesStepper;
@synthesize platformDistance;
@synthesize platformSpeed;
@synthesize platformWidth;

- (void) initNewWorlds {
    fileName = nil;
    if (worlds != nil) {
        [worlds removeAllObjects];
    } else {
        worlds = [NSMutableDictionary dictionary];
    }
    NSDictionary *levels = [NSMutableDictionary dictionary];
    NSArray *levelArray = [NSArray array];
    [levels setValue:levelArray forKey:@"Level01"];
    [worlds setValue:levels forKey:@"World0"];
    
    
    levels = [NSMutableDictionary dictionary];
    levelArray = [NSArray array];
    [levels setValue:levelArray forKey:@"Level01"];
    [worlds setValue:levels forKey:@"World1"];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initNewWorlds];
    // Insert code here to initialize your application
}


- (IBAction)showOpenPanel:(id)sender {
    [self.stretchView unselectAllGameObjects];
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSImage imageFileTypes]];
    [panel beginSheetModalForWindow:[self.stretchView window] 
                  completionHandler:^ (NSInteger result) {
                      
        if (result == NSOKButton) {
            GameObject *image = [[GameObject alloc] initWithContentsOfURL:[panel URL]];
            image.position = CGPointMake(50, 0);
            [self.stretchView addGameObject:image isSelected:YES];
        }
        panel = nil;
     }];
}

// Needed for open recent menu item
- (BOOL) application:(NSApplication *)sender openFile:(NSString *)filename {

    fileName = [NSURL fileURLWithPath:filename];
    [self.stretchView clearCanvas];
    [self loadLevelFromFile];

    return YES;
}

- (IBAction)openLevel:(id)sender {
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];
    
    [panel beginSheetModalForWindow:[self.stretchView window] 
                  completionHandler:^ (NSInteger result) {
                      
                      if (result == NSOKButton) {
                          fileName = [[panel URL] copy];
                          
                          // Add it to the open recent menu
                          [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:fileName];
                          
                          [self.stretchView clearCanvas];
                          [self loadLevelFromFile];
                      }
                      panel = nil;
                  }];
    
}

- (void) addCommonGameObjectsToDropdown {
    [gameObjects addItemWithObjectValue:@"Pole"];
    [gameObjects addItemWithObjectValue:@"Cannon"];
    [gameObjects addItemWithObjectValue:@"Spring"];    
    [gameObjects addItemWithObjectValue:@"Hunter"];    
//    [gameObjects addItemWithObjectValue:@"Elephant"];
    [gameObjects addItemWithObjectValue:@"Wheel"];
    [gameObjects addItemWithObjectValue:@"Floating Platform"];    
    [gameObjects addItemWithObjectValue:@"Falling Platform"];
    [gameObjects addItemWithObjectValue:@"Final Platform"];
    [gameObjects addItemWithObjectValue:@"Coin"];
    [gameObjects addItemWithObjectValue:@"Star"];
    [gameObjects addItemWithObjectValue:@"Magnet"];    
    [gameObjects addItemWithObjectValue:@"Strong Man"];
    [gameObjects addItemWithObjectValue:@"Fire Ring"];
    [gameObjects addItemWithObjectValue:@"Anger Potion"];
    [gameObjects addItemWithObjectValue:@"Block"];
    [gameObjects addItemWithObjectValue:@"Oil Barrel"];
    [gameObjects addItemWithObjectValue:@"Jet Pack"];
    [gameObjects addItemWithObjectValue:@"Missile Launcher"];
    [gameObjects addItemWithObjectValue:@"Insect"];
    [gameObjects addItemWithObjectValue:@"Saw"];
    [gameObjects addItemWithObjectValue:@"Speed Boost"];
    [gameObjects addItemWithObjectValue:@"Dummy"];
}

- (void) awakeFromNib {
    CGRect frame = [self.stretchView frame];
    [gameWorldSize setStringValue:[NSString stringWithFormat:@"Game World Size (%.2f, %.2f)", frame.size.width, frame.size.height]]; 
    [levelField setIntValue:1];
    [maxLevelField setStringValue:@"of 1"];
    
    [worldNames addItemWithObjectValue:WORLD_GRASSY_KNOLLS];
    [worldNames addItemWithObjectValue:WORLD_FOREST_RETREAT];
    [worldNames setStringValue:WORLD_GRASSY_KNOLLS];
    oldWorldsName = WORLD_GRASSY_KNOLLS;
    
    [self addCommonGameObjectsToDropdown];
    [gameObjects addItemWithObjectValue:@"Tree Clump 1"];
    [gameObjects addItemWithObjectValue:@"Tree Clump 2"];
    [gameObjects addItemWithObjectValue:@"Tree Clump 3"];
    [gameObjects addItemWithObjectValue:@"Tent 1"];
    [gameObjects addItemWithObjectValue:@"Tent 2"];
    [gameObjects addItemWithObjectValue:@"Balloon Cart"];
    [gameObjects addItemWithObjectValue:@"Popcorn Cart"];
    [gameObjects addItemWithObjectValue:@"Boxes"];
    
    [numCopies setIntValue:1];
    [numCopiesStepper setIntValue:1];
}

- (void) loadWorld:(NSString*)worldName level:(int)levelNumber {
    [self.stretchView clearCanvas];

    NSString *convertedWorldName = [GPUtil convertedWorldName:worldName];

    CGFloat maxXPosition = 0.0;
    CGFloat maxYPosition = 0.0;
    NSDictionary *world = [worlds objectForKey:convertedWorldName];
    NSString *format;
    if (levelNumber < 10) {
        format = @"Level0%d";
    } else {
        format = @"Level%d";
    }
    
    NSMutableArray *levelItems = [world objectForKey:[NSString stringWithFormat:format, levelNumber]];
    if ([levelItems count] > 0) {
        // First sort by z-order
        NSArray *sortedLevelItems = [levelItems sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
            NSDictionary *item1 = (NSDictionary*) obj1;
            NSDictionary *item2 = (NSDictionary*) obj2;
            CGFloat x1 = [[item1 objectForKey:@"Z-Order"] floatValue];
            CGFloat x2 = [[item2 objectForKey:@"Z-Order"] floatValue];
            if (x1 > x2) {
                return (NSComparisonResult) NSOrderedDescending;
            }
            if (x1 < x2) {
                return (NSComparisonResult) NSOrderedAscending;
            }
            
            return (NSComparisonResult) NSOrderedSame;
        }];

        levelItems = [sortedLevelItems mutableCopy];
        
        // Calculate canvas size
        for (NSDictionary *level in levelItems) {
            CGFloat xpos = [[level objectForKey:@"XPosition"] floatValue]*2;
            CGFloat ypos = [[level objectForKey:@"YPosition"] floatValue]*2;
            maxXPosition = MAX(xpos, maxXPosition);
            maxYPosition = MAX(ypos, maxYPosition);
        }
        
        maxXPosition = MAX(maxXPosition, 1);
        maxYPosition = MAX(maxYPosition, 1);
        
        int xmultiples = maxXPosition / self.stretchView.deviceScreenWidth;
        CGFloat remainderx = maxXPosition - (self.stretchView.deviceScreenWidth * xmultiples);
        if (remainderx > 0.f) {
            xmultiples++;
        }

        int ymultiples = maxYPosition / self.stretchView.deviceScreenHeight;
        CGFloat remaindery = maxYPosition - (self.stretchView.deviceScreenHeight * ymultiples);
        if (remaindery > 0.f) {
            ymultiples++;
        }
        
        CGFloat width = self.stretchView.deviceScreenWidth * (xmultiples+1);
        CGFloat height = MAX([self.stretchView frame].size.height, self.stretchView.deviceScreenHeight * (ymultiples+1));
        CGRect newFrame = CGRectMake(0.f, 0.f, width, height);
        [self.stretchView setFrame:newFrame];
        
        [self.stretchView loadLevel:levelItems];    
    }
//    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
//    [sv verticalScroller].floatValue = 0.f;
//    [sv scrollPoint:CGPointMake(0, 0)];
//    [sv.verticalScroller setFloatValue:0];
}

- (void) loadLevelFromFile {
    NSData *plistData = [NSData dataWithContentsOfURL:fileName];
    NSString *error;
    NSPropertyListFormat format;
    
    worlds = [NSPropertyListSerialization propertyListFromData:plistData
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                        format:&format
                                              errorDescription:&error];    
    
    [self loadWorld:WORLD_GRASSY_KNOLLS level:1];
    [levelStepper setIntValue:1];
    [levelField setIntValue:1];
    int maxLevels = (int)[[worlds objectForKey:[GPUtil convertedWorldName:WORLD_GRASSY_KNOLLS]] count];
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", maxLevels]];
}

- (void) writeLevelToFile {
    NSArray *levelsArray = [self.stretchView levelForSerialization];

    NSString *format;
    if ([levelField intValue] < 10) {
        format = @"Level0%d";
    } else {
        format = @"Level%d";
    }

    NSString *currentLevel = [NSString stringWithFormat:format, [levelField intValue]];
    NSDictionary *world = [worlds objectForKey:[GPUtil convertedWorldName:[worldNames stringValue]]];
    [world setValue:levelsArray forKey:currentLevel];
    
    [worlds setValue:world forKey:[GPUtil convertedWorldName:[worldNames stringValue]]];
    
    NSString *error;
    NSData *pList = [NSPropertyListSerialization dataFromPropertyList:worlds 
                                                               format:NSPropertyListXMLFormat_v1_0 
                                                     errorDescription:&error];
    [pList writeToURL:fileName atomically:NO];                
}

- (IBAction)saveAs:(id)sender {
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    // Restrict the file type to whatever you like
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];

    // Set the starting directory
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:@"~/Desktop"]];
    
    // Perform other setup
    // Use a completion handler -- this is a block which takes one argument
    // which corresponds to the button that was clicked
    [savePanel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            // Close panel before handling errors
            [savePanel orderOut:self]; 
            
            //NSLog(@"Got URL: %@", [savePanel URL]);
            // Do what you need to do with the selected path
            fileName = [[savePanel URL] copy];
            [self writeLevelToFile];
        }
    }];
}

- (IBAction)save:(id)sender {
    if (fileName != nil) {
        [self writeLevelToFile];
    } else {
        [self saveAs:sender];
    }
}

- (IBAction)showHelp:(id)sender {
    NSURL * helpFile = [[NSBundle mainBundle] URLForResource:@"help" withExtension:@"html"];
    [[NSWorkspace sharedWorkspace] openURL:helpFile];
}


- (void) synchronizeCurrentLevel {
    NSArray *levelItems = [self.stretchView levelForSerialization];
    
    NSString *format;
    if ([levelField intValue] < 10) {
        format = @"Level0%d";
    } else {
        format = @"Level%d";
    }
    
    NSString *currentLevel = [NSString stringWithFormat:format, [levelField intValue]];

    NSString *converted = [GPUtil convertedWorldName:oldWorldsName];
    NSDictionary *world = [worlds objectForKey:converted];
    NSLog(@"SYnchronigin %@ %@ currentLevel=%@ %ld", oldWorldsName, converted, currentLevel, [world count]);
    [world setValue:levelItems forKey:currentLevel];
    
    [worlds setValue:world forKey:converted];
    
    NSLog(@"SYnchronigin %@ %@ currentLevel=%@ %ld", oldWorldsName, converted, currentLevel, [world count]);
}


- (IBAction)addLevel:(id)sender {
    [self synchronizeCurrentLevel];
    
    // Add dummy level as place holder
    NSDictionary *world = [worlds objectForKey:[GPUtil convertedWorldName:[worldNames stringValue]]];
    int numLevels = (int)[world count];
    NSArray *levelArray = [NSArray array];

    numLevels++;

    NSString *format;
    if (numLevels < 10) {
        format = @"Level0%d";
    } else {
        format = @"Level%d";
    }
    
    
    [world setValue:levelArray forKey:[NSString stringWithFormat:format, numLevels]];
    // Update level fields on screen
    [levelField setIntValue:numLevels];
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", numLevels]];
    
    [levelStepper setIntValue:numLevels];
    [self.stretchView clearCanvas];
}

- (IBAction)newDocument:(id)sender {
    [self initNewWorlds];
    
    [levelField setIntValue:1];
    [maxLevelField setStringValue:@"of 1"];
    [levelStepper setIntValue:1];
    [self.stretchView clearCanvas];
    [self.stretchView setNeedsDisplay:YES];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSComboBox *comboBox = (NSComboBox *)[notification object];
    if (comboBox == self.worldNames) {
        NSString *str = [comboBox itemObjectValueAtIndex:[comboBox indexOfSelectedItem]];
        
        [self synchronizeCurrentLevel];
        oldWorldsName = str;


        [gameObjects removeAllItems];
        [gameObjects setStringValue:@""];    
        [levelField setIntValue:1];
        [levelStepper setIntegerValue:1];
        
        NSDictionary *world = [worlds objectForKey:[GPUtil convertedWorldName:str]];
        [maxLevelField setIntValue:(int)[world count]];
        
        if ([WORLD_GRASSY_KNOLLS isEqualToString:str]) {
            [self addCommonGameObjectsToDropdown];
            [gameObjects addItemWithObjectValue:@"Tree Clump 1"];
            [gameObjects addItemWithObjectValue:@"Tree Clump 2"];
            [gameObjects addItemWithObjectValue:@"Tree Clump 3"];
            [gameObjects addItemWithObjectValue:@"Tent 1"];
            [gameObjects addItemWithObjectValue:@"Tent 2"];
            [gameObjects addItemWithObjectValue:@"Balloon Cart"];
            [gameObjects addItemWithObjectValue:@"Popcorn Cart"];
            [gameObjects addItemWithObjectValue:@"Boxes"];
            

            [self loadWorld:WORLD_GRASSY_KNOLLS level:1];
        }
        else if ([WORLD_FOREST_RETREAT isEqualToString:str]) {
            [self addCommonGameObjectsToDropdown];
            [gameObjects addItemWithObjectValue:@"Torch"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 1"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 2"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 3"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 1"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 2"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 3"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 4"];

            [self loadWorld:WORLD_FOREST_RETREAT level:1];
        }
    }
}

- (IBAction)addGameObject:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject;
    
    NSString *val = [self.gameObjects stringValue];
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    
    for (int i = 0; i < [numCopies intValue]; i++) {
        gameObject = [GameObject instanceOf:val];
        
        gameObject.position = CGPointMake(r.origin.x + gameObject.anchorXOffset, r.origin.y + gameObject.anchorYOffset);
        
        BOOL selected = NO;
        if (i == [numCopies intValue]-1) {
            selected = YES;
        }
        [self.stretchView addGameObject:gameObject isSelected:selected];
        
        if ([gameObject isKindOfClass:[Cannon class]]) {
            Cannon *cannon = (Cannon*)gameObject;
            
            for (NSValue *val in cannon.trajectories) {
                GameObject *coin = [GameObject instanceOf:@"Coin"];
                CGPoint p = [val pointValue];
                coin.position = CGPointMake(r.origin.x + p.x + coin.anchorXOffset, r.origin.y + p.y + coin.anchorYOffset);
                [self.stretchView addGameObject:coin isSelected:NO];
                
            }
        }
    }
}

- (void) controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = (NSTextField*)[obj object];
    
    if (levelField == textField) {
        [levelStepper setIntValue:[levelField intValue]];
        [self loadWorld:[worldNames stringValue] level:[levelField intValue]];
    } else if (zOrder == textField) {
        [zOrderStepper setIntValue:[zOrder intValue]];
    } else if (numCopies == textField) {
        [numCopiesStepper setIntValue:[numCopies intValue]];
    }
    [self.stretchView updateSelectedGameObject];
}


- (IBAction)stepperAction:(id)sender {
    if (sender == levelStepper) {
        NSDictionary *world = [worlds objectForKey:[GPUtil convertedWorldName:[worldNames stringValue]]];
        if ([levelStepper intValue] <= [world count]) {
            NSArray *levelItems = [self.stretchView levelForSerialization];
            
            NSString *format;
            if ([levelField intValue] < 10) {
                format = @"Level0%d";
            } else {
                format = @"Level%d";
            }
            
            NSString *currentLevel = [NSString stringWithFormat:format, [levelField intValue]];
            [world setValue:levelItems forKey:currentLevel];

            [levelField setIntValue:[levelStepper intValue]];
            [self loadWorld:[worldNames stringValue] level:[levelField intValue]];
        } else {
            [levelStepper setIntValue:(int)[world count]-1];
        }
    } else if (sender == zOrderStepper) {
        [zOrder setIntValue:[zOrderStepper intValue]];
        [self.stretchView updateSelectedGameObject];
        //[self.stretchView updateSelectedZOrder:[zOrder intValue]];        
    } else if (sender == numCopiesStepper) {
        [numCopies setIntValue:[numCopiesStepper intValue]];
    }
}


- (IBAction)resizeCanvas:(id)sender {
    SetCanvasSizeWindowController *w = [[SetCanvasSizeWindowController alloc] initWithWindowNibName:@"SetCanvasSizeWindowController"];
    
    w.width = [self.stretchView frame].size.width;
    w.height = [self.stretchView frame].size.height;
    w.deviceScreenWidth = self.stretchView.deviceScreenWidth;
    w.deviceScreenHeight = self.stretchView.deviceScreenHeight;

    // Show document sheet
    [NSApp beginSheet:[w window] 
       modalForWindow:[self window] 
        modalDelegate:nil 
       didEndSelector:nil 
          contextInfo:nil];
    
    int acceptedModal = (int)[NSApp runModalForWindow:[w window]];
    
    [NSApp endSheet:[w window]];
    [[w window] close];
    
    
    if (acceptedModal) {
        CGFloat width = [w.widthField floatValue];
        CGFloat height = [w.heightField floatValue];
        CGRect newFrame = CGRectMake(0.f, 0.f, width, height);
        [self.stretchView setFrame:newFrame];
        
        self.stretchView.deviceScreenWidth = [w.deviceWidthField floatValue];
        self.stretchView.deviceScreenHeight = [w.deviceHeightField floatValue];
        [self.stretchView setNeedsDisplay:YES];
    }
    
}

@end
