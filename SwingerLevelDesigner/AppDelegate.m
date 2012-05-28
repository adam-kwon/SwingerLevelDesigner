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
@synthesize position;
@synthesize swingSpeed;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    fileName = nil;
    // Insert code here to initialize your application
}

- (IBAction)showOpenPanel:(id)sender {
//    [stretchView unselectAllGameObjects];
//    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
//    [panel setAllowedFileTypes:[NSImage imageFileTypes]];
//    [panel beginSheetModalForWindow:[stretchView window] 
//                  completionHandler:^ (NSInteger result) {
//                      
//        if (result == NSOKButton) {
//            GameObject *image = [[GameObject alloc] initWithContentsOfURL:[panel URL]];
//            [stretchView addGameObject:image];
//        }
//        panel = nil;
//     }];
}

// Needed for open recent menu item
- (BOOL) application:(NSApplication *)sender openFile:(NSString *)filename {

    fileName = [NSURL fileURLWithPath:filename];
    [stretchView clearCanvas];
    [self loadLevelFromFile];

    return YES;
}

- (IBAction)openLevel:(id)sender {
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];
    
    [panel beginSheetModalForWindow:[stretchView window] 
                  completionHandler:^ (NSInteger result) {
                      
                      if (result == NSOKButton) {
                          fileName = [[panel URL] copy];
                          
                          // Add it to the open recent menu
                          [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:fileName];
                          
                          [stretchView clearCanvas];
                          [self loadLevelFromFile];
                      }
                      panel = nil;
                  }];
    
}

- (void) awakeFromNib {
    CGRect frame = [stretchView frame];
    [gameWorldSize setStringValue:[NSString stringWithFormat:@"Game World Size (%.2f, %.2f)", frame.size.width, frame.size.height]]; 
}

- (void) loadLevelFromFile {
    NSData *plistData = [NSData dataWithContentsOfURL:fileName];
    NSString *error;
    NSPropertyListFormat format;
    
    NSDictionary *levels = [NSPropertyListSerialization propertyListFromData:plistData
                                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                      format:&format
                                                            errorDescription:&error];


    // Calculate canvas size
    CGFloat maxPosition = 0.0;
    NSArray *levelItems = [levels objectForKey:@"Level0"];
    for (NSDictionary *level in levelItems) {
        CGFloat pos = [[level objectForKey:@"Position"] floatValue];
        maxPosition = MAX(pos, maxPosition);
    }
    
    CGFloat lastItemPosition = maxPosition * stretchView.deviceScreenWidth;
    int multiples = lastItemPosition / stretchView.deviceScreenWidth;
    CGFloat remainder = lastItemPosition - (stretchView.deviceScreenWidth * multiples);
    if (remainder > 0.f) {
        multiples++;
    }
    
    CGFloat width = stretchView.deviceScreenWidth * multiples;
    CGFloat height = [stretchView frame].size.height;
    CGRect newFrame = CGRectMake(0.f, 0.f, width, height);
    [stretchView setFrame:newFrame];
    
    [stretchView loadLevels:levels];
}

- (void) writeLevelToFile {
    NSMutableDictionary *rootDict = [NSMutableDictionary dictionary];
    
    NSArray *levelsArray = [stretchView levelForSerialization];
    
    [rootDict setObject:levelsArray forKey:@"Level0"];
    
    NSString *error;
    NSData *pList = [NSPropertyListSerialization dataFromPropertyList:rootDict 
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

- (IBAction)addPole:(id)sender {
    [stretchView unselectAllGameObjects];
    
    GameObject *gameObject = [[GameObject alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SwingPole1" ofType:@"png"]];
    gameObject.gameObjectType = kGameObjectTypeSwinger;
    gameObject.position = CGPointZero;
    
    [stretchView addGameObject:gameObject isSelected:YES];
}

- (void) controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *textField = (NSTextField*)[obj object];
    

    if (textField == xPosition || textField == yPosition) {
        //NSLog(@"SETTING PSITIOn SPEED");
        [stretchView updateSelectedPosition:CGPointMake([xPosition floatValue], [yPosition floatValue])];
    } else if (textField == swingSpeed) {
        //NSLog(@"SETTING SWING SPEED");
        [stretchView updateSelectedSwingSpeed:[swingSpeed floatValue]];
    }
}

- (IBAction)resizeCanvas:(id)sender {
    SetCanvasSizeWindowController *w = [[SetCanvasSizeWindowController alloc] initWithWindowNibName:@"SetCanvasSizeWindowController"];
    
    w.width = [stretchView frame].size.width;
    w.height = [stretchView frame].size.height;
    w.deviceScreenWidth = stretchView.deviceScreenWidth;
    w.deviceScreenHeight = stretchView.deviceScreenHeight;

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
        [stretchView setFrame:newFrame];
        
        stretchView.deviceScreenWidth = [w.deviceWidthField floatValue];
        stretchView.deviceScreenHeight = [w.deviceHeightField floatValue];
    }
    
}

@end
