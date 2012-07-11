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
#import "Constants.h"

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
@synthesize leftEdge;
@synthesize rightEdge;
@synthesize walkVelocity;
@synthesize wheelSpeed;
@synthesize worldNames;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    fileName = nil;
    worlds = [NSMutableDictionary dictionary];
    NSDictionary *levels = [NSMutableDictionary dictionary];
    NSArray *levelArray = [NSArray array];
    [levels setValue:levelArray forKey:@"Level0"];
    [worlds setValue:levels forKey:@"World0"];

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

- (void) awakeFromNib {
    CGRect frame = [self.stretchView frame];
    [gameWorldSize setStringValue:[NSString stringWithFormat:@"Game World Size (%.2f, %.2f)", frame.size.width, frame.size.height]]; 
    [levelField setIntValue:0];
    [maxLevelField setStringValue:@"of 0"];
    
    [worldNames addItemWithObjectValue:WORLD_GRASSY_KNOLLS];
    [worldNames addItemWithObjectValue:WORLD_FOREST_RETREAT];
    [worldNames setStringValue:WORLD_GRASSY_KNOLLS];
    
    [gameObjects addItemWithObjectValue:@"Pole"];
    [gameObjects addItemWithObjectValue:@"Cannon"];
    [gameObjects addItemWithObjectValue:@"Spring"];    
    [gameObjects addItemWithObjectValue:@"Elephant"];
    [gameObjects addItemWithObjectValue:@"Wheel"];
    [gameObjects addItemWithObjectValue:@"Final Platform"];
    [gameObjects addItemWithObjectValue:@"Coin"];
    [gameObjects addItemWithObjectValue:@"Star"];
    [gameObjects addItemWithObjectValue:@"Tree Clump 1"];
    [gameObjects addItemWithObjectValue:@"Tree Clump 2"];
    [gameObjects addItemWithObjectValue:@"Tree Clump 3"];
    [gameObjects addItemWithObjectValue:@"Tent 1"];
    [gameObjects addItemWithObjectValue:@"Tent 2"];
    [gameObjects addItemWithObjectValue:@"Balloon Cart"];
    [gameObjects addItemWithObjectValue:@"Popcorn Cart"];
    [gameObjects addItemWithObjectValue:@"Boxes"];
    [gameObjects addItemWithObjectValue:@"Strong Man"];
    [gameObjects addItemWithObjectValue:@"Dummy"];
}

- (NSString*) convertedWorldName:(NSString*)worldName {
    if ([WORLD_GRASSY_KNOLLS isEqualToString:worldName]) {
        return @"World0";
    }
    else if ([WORLD_FOREST_RETREAT isEqualToString:worldName]) {
        return @"World1";
    }
    return @"";
}

- (void) loadWorld:(NSString*)worldName level:(int)levelNumber {
    NSString *convertedWorldName = [self convertedWorldName:worldName];
    
    CGFloat maxXPosition = 0.0;
    CGFloat maxYPosition = 0.0;
    NSDictionary *world = [worlds objectForKey:convertedWorldName];
    NSArray *levelItems = [world objectForKey:[NSString stringWithFormat:@"Level%d", levelNumber]];
    if ([levelItems count] > 0) {
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
        
        [self.stretchView clearCanvas];
        [self.stretchView loadLevel:levelItems];    
    } else {
        [self.stretchView clearCanvas];
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

    [self loadWorld:WORLD_GRASSY_KNOLLS level:0];
    [levelStepper setIntValue:0];
    [levelField setIntValue:0];
    int maxLevels = [[worlds objectForKey:[self convertedWorldName:WORLD_GRASSY_KNOLLS]] count] - 1;
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", maxLevels]];
}

- (void) writeLevelToFile {
    NSArray *levelsArray = [self.stretchView levelForSerialization];

    NSString *currentLevel = [NSString stringWithFormat:@"Level%d", [levelField intValue]];
    NSDictionary *world = [worlds objectForKey:[self convertedWorldName:[worldNames stringValue]]];
    [world setValue:levelsArray forKey:currentLevel];
    
    [worlds setValue:world forKey:[self convertedWorldName:[worldNames stringValue]]];
    
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
    NSString *currentLevel = [NSString stringWithFormat:@"Level%d", [levelField intValue]];

    NSDictionary *world = [worlds objectForKey:[worldNames stringValue]];
    [world setValue:levelItems forKey:currentLevel];
    
    [worlds setValue:world forKey:[worldNames stringValue]];    
}


- (IBAction)addLevel:(id)sender {
    [self synchronizeCurrentLevel];
    
    // Add dummy level as place holder
    NSDictionary *world = [worlds objectForKey:[self convertedWorldName:[worldNames stringValue]]];
    int numLevels = [world count];
    NSArray *levelArray = [NSArray array];
    [world setValue:levelArray forKey:[NSString stringWithFormat:@"Level%d", numLevels]];

    // Update level fields on screen
    [levelField setIntValue:numLevels];
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", numLevels]];
    
    [levelStepper setIntValue:numLevels];
    [self.stretchView clearCanvas];
}

- (IBAction)newDocument:(id)sender {
    if (worlds == nil) {
        worlds = [NSMutableDictionary dictionary];
    } else {
        [worlds removeAllObjects];
    }
    NSArray *levelArray = [NSArray array];
    NSDictionary *world = [NSDictionary dictionary];
    [worlds setValue:world forKey:@"World0"];
    
    [world setValue:levelArray forKey:@"Level0"];
    [levelField setIntValue:0];
    [maxLevelField setStringValue:@"of 0"];
    [levelStepper setIntValue:0];
    [self.stretchView clearCanvas];
    [self.stretchView setNeedsDisplay:YES];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSComboBox *comboBox = (NSComboBox *)[notification object];
    if (comboBox == self.worldNames) {
        NSString *str = [comboBox itemObjectValueAtIndex:[comboBox indexOfSelectedItem]];
        
        [gameObjects removeAllItems];
            
        if ([WORLD_GRASSY_KNOLLS isEqualToString:str]) {
            [gameObjects addItemWithObjectValue:@"Pole"];
            [gameObjects addItemWithObjectValue:@"Cannon"];
            [gameObjects addItemWithObjectValue:@"Spring"];    
            [gameObjects addItemWithObjectValue:@"Elephant"];
            [gameObjects addItemWithObjectValue:@"Wheel"];
            [gameObjects addItemWithObjectValue:@"Final Platform"];
            [gameObjects addItemWithObjectValue:@"Coin"];
            [gameObjects addItemWithObjectValue:@"Star"];
            [gameObjects addItemWithObjectValue:@"Tree Clump 1"];
            [gameObjects addItemWithObjectValue:@"Tree Clump 2"];
            [gameObjects addItemWithObjectValue:@"Tree Clump 3"];
            [gameObjects addItemWithObjectValue:@"Tent 1"];
            [gameObjects addItemWithObjectValue:@"Tent 2"];
            [gameObjects addItemWithObjectValue:@"Balloon Cart"];
            [gameObjects addItemWithObjectValue:@"Popcorn Cart"];
            [gameObjects addItemWithObjectValue:@"Boxes"];
            [gameObjects addItemWithObjectValue:@"Strong Man"];
            [gameObjects addItemWithObjectValue:@"Dummy"];
            
            [self loadWorld:WORLD_GRASSY_KNOLLS level:0];
        }
        else if ([WORLD_FOREST_RETREAT isEqualToString:str]) {
            [gameObjects addItemWithObjectValue:@"Pole"];
            [gameObjects addItemWithObjectValue:@"Cannon"];
            [gameObjects addItemWithObjectValue:@"Spring"];    
            [gameObjects addItemWithObjectValue:@"Elephant"];
            [gameObjects addItemWithObjectValue:@"Wheel"];
            [gameObjects addItemWithObjectValue:@"Final Platform"];
            [gameObjects addItemWithObjectValue:@"Coin"];
            [gameObjects addItemWithObjectValue:@"Star"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 1"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 2"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree Clump 3"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 1"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 2"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 3"];
            [gameObjects addItemWithObjectValue:@"Forest Retreat Tree 4"];
            [gameObjects addItemWithObjectValue:@"Strong Man"];
            [gameObjects addItemWithObjectValue:@"Dummy"];            

            [self loadWorld:WORLD_FOREST_RETREAT level:0];
        }
    }
}

- (IBAction)addGameObject:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject;
    
    NSString *val = [self.gameObjects stringValue];
    
    gameObject = [GameObject instanceOf:val];
    
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x + gameObject.anchorXOffset, 0 + gameObject.anchorYOffset);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];    
}


- (void) controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = (NSTextField*)[obj object];
    
    if (levelField == textField) {
        [levelStepper setIntValue:[levelField intValue]];
        [self loadWorld:[worldNames stringValue] level:[levelField intValue]];
    }
    [self.stretchView updateSelectedGameObject];
}


- (IBAction)stepperAction:(id)sender {
    if (sender == levelStepper) {
        NSDictionary *world = [worlds objectForKey:[self convertedWorldName:[worldNames stringValue]]];
        if ([levelStepper intValue] < [world count]) {
            NSArray *levelItems = [self.stretchView levelForSerialization];
            NSString *currentLevel = [NSString stringWithFormat:@"Level%d", [levelField intValue]];
            [world setValue:levelItems forKey:currentLevel];

            [levelField setIntValue:[levelStepper intValue]];
            [self loadWorld:[worldNames stringValue] level:[levelField intValue]];
        } else {
            [levelStepper setIntValue:[world count]-1];
        }
    } else if (sender == zOrderStepper) {
        [zOrder setIntValue:[zOrderStepper intValue]];
        [self.stretchView updateSelectedGameObject];
        //[self.stretchView updateSelectedZOrder:[zOrder intValue]];        
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
