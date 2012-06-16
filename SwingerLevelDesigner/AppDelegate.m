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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    fileName = nil;
    levels = [NSMutableDictionary dictionary];
    NSArray *levelArray = [NSArray array];
    [levels setValue:levelArray forKey:@"Level0"];

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
    
}

- (void) loadLevel:(int)levelNumber {
    CGFloat maxXPosition = 0.0;
    CGFloat maxYPosition = 0.0;
    NSArray *levelItems = [levels objectForKey:[NSString stringWithFormat:@"Level%d", levelNumber]];
    if ([levelItems count] > 0) {
        // Calculate canvas size
        for (NSDictionary *level in levelItems) {
            CGFloat xpos = [[level objectForKey:@"XPosition"] floatValue];
            CGFloat ypos = [[level objectForKey:@"YPosition"] floatValue];
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
    
    levels = [NSPropertyListSerialization propertyListFromData:plistData
                                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                      format:&format
                                                            errorDescription:&error];

    [self loadLevel:0];
    [levelStepper setIntValue:0];
    [levelField setIntValue:0];
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", [levels count]-1]];
}

- (void) writeLevelToFile {
    NSArray *levelsArray = [self.stretchView levelForSerialization];

    NSString *currentLevel = [NSString stringWithFormat:@"Level%d", [levelField intValue]];
    [levels setValue:levelsArray forKey:currentLevel];
    
    NSString *error;
    NSData *pList = [NSPropertyListSerialization dataFromPropertyList:levels 
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
    [levels setValue:levelItems forKey:currentLevel];    
}


- (IBAction)addLevel:(id)sender {
    [self synchronizeCurrentLevel];
    
    // Add dummy level as place holder
    int numLevels = [levels count];
    NSArray *levelArray = [NSArray array];
    [levels setValue:levelArray forKey:[NSString stringWithFormat:@"Level%d", numLevels]];

    // Update level fields on screen
    [levelField setIntValue:numLevels];
    [maxLevelField setStringValue:[NSString stringWithFormat:@"of %d", numLevels]];
    
    [levelStepper setIntValue:numLevels];
    [self.stretchView clearCanvas];
}

- (IBAction)newDocument:(id)sender {
    if (levels == nil) {
        levels = [NSMutableDictionary dictionary];
    } else {
        [levels removeAllObjects];
    }
    NSArray *levelArray = [NSArray array];
    [levels setValue:levelArray forKey:@"Level0"];
    [levelField setIntValue:0];
    [maxLevelField setStringValue:@"of 0"];
    [levelStepper setIntValue:0];
    [self.stretchView clearCanvas];
    [self.stretchView setNeedsDisplay:YES];
}

- (IBAction)addFinalPlatform:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"finalPlatform" ofType:@"png"] 
                                                                 parent:self.stretchView];
    gameObject.gameObjectType = kGameObjectTypeFinalPlatform;    
    
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x, 0);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];    
}


- (IBAction)addCannon:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cannon" ofType:@"png"]
                                                                 parent:self.stretchView];
    gameObject.gameObjectType = kGameObjectTypeCannon;
    
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x, 0);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];    
}

- (IBAction)addDummy:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dummy" ofType:@"png"]
                                                                 parent:self.stretchView];
    gameObject.gameObjectType = kGameObjectTypeDummy;
    
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x, 0);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];
}

- (IBAction)addStar:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"]
                                                                 parent:self.stretchView];
    gameObject.gameObjectType = kGameObjectTypeStar;
    
    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x, 50);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];
}


- (IBAction)addPole:(id)sender {
    [self.stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SwingPole1" ofType:@"png"]
                                                                 parent:self.stretchView];
    gameObject.gameObjectType = kGameObjectTypeSwinger;

    NSScrollView *sv = (NSScrollView*)self.stretchView.superview;
    NSRect r = [sv documentVisibleRect];
    gameObject.position = CGPointMake(r.origin.x, 0);
    
    [self.stretchView addGameObject:gameObject isSelected:YES];
}

- (void) controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = (NSTextField*)[obj object];
    

    if (textField == xPosition || textField == yPosition) {
        [self.stretchView updateSelectedPosition:CGPointMake([xPosition floatValue], [yPosition floatValue])];
    } else if (textField == period) {
        [self.stretchView updateSelectedPeriod:[period floatValue]];
    } 
    else if (textField == ropeLength) {
        [self.stretchView updateSelectedRopeLength:[ropeLength floatValue]];
    }
    else if (textField == grip) {
        [self.stretchView updateSelectedGrip:[grip floatValue]];
    }
    else if (textField == poleScale) {
        [self.stretchView updateSelectedPoleScale:[poleScale floatValue]];
    }
    else if (textField == windSpeed) {
        [self.stretchView updateSelectedWindSpeed:[windSpeed floatValue]];
    }
    else if (textField == windDirection) {
        [self.stretchView updateSelectedWindDirection:[windDirection stringValue]];
    }
    else if (textField == swingAngle) {
        [self.stretchView updateSelectedSwingAngle:[swingAngle floatValue]];
    }
    else if (textField == levelField) {
        if ([textField intValue] != [levelStepper intValue]) {
            [levelStepper setIntValue:[levelField intValue]];
            [self loadLevel:[levelField intValue]];
        }
    }
    else if (textField == cannonSpeed) {
        [self.stretchView updateSelectedCannonSpeed:[cannonSpeed floatValue]];
    }
    else if (textField == cannonForce) {
        [self.stretchView updateSelectedCannonForce:[cannonForce floatValue]];
    }
    else if (textField == cannonRotationAngle) {
        [self.stretchView updateSelectedCannonRotationAngle:[cannonRotationAngle floatValue]];
    }
}

- (IBAction)stepperAction:(id)sender {
    if ([levelStepper intValue] < [levels count]) {
        NSArray *levelItems = [self.stretchView levelForSerialization];
        NSString *currentLevel = [NSString stringWithFormat:@"Level%d", [levelField intValue]];
        [levels setValue:levelItems forKey:currentLevel];

        [levelField setIntValue:[levelStepper intValue]];
        [self loadLevel:[levelStepper intValue]];
    } else {
        [levelStepper setIntValue:[levels count]-1];
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
