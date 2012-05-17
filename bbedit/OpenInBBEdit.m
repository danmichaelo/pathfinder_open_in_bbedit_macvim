//
//  OpenInBBEdit.m
//  pathfinder_open_in_bbedit
//
//  Created by orta therox on 06/09/2010.
//  Copyright 2010 wgrids. All rights reserved.
//

#import "OpenInBBEdit.h"


@implementation OpenInBBEdit

@synthesize host;

+ (id)plugin:(id<NTPathFinderPluginHostProtocol>)pathfinder_host;
{
  OpenInBBEdit* result = [[self alloc] init];
  result.host = pathfinder_host;
  
  return [result autorelease];
}

- (NSMenuItem*)contextualMenuItem;
{
	return [self menuItem];
}

- (NSMenuItem*)menuItem;
{
  NSMenuItem* menuItem;
	
  menuItem = [[[NSMenuItem alloc] initWithTitle:@"Open in BBEdit" action:@selector(pluginAction:) keyEquivalent:@""] autorelease];
  [menuItem setTarget:self];
	[menuItem setKeyEquivalentModifierMask: NSControlKeyMask | NSCommandKeyMask];
  return menuItem;
}

- (void)pluginAction:(id)sender;
{
  [self processItems:nil parameter:nil];
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem;
{
  return [[[self host] selection:nil browserID:nil] count] > 0;
}

- (id)processItems:(NSArray*)items parameter:(id)parameter;
{
	if (!items)
		items = [self.host  selection:nil browserID:nil];

  // Iterate over Path Finder selection
  NSEnumerator* enumerator = [items objectEnumerator];
  NSString *path;
  id<NTFSItem> item;
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
  while ((item = [enumerator nextObject]))
   {
		path = [item path];
		if (path)
     {
         [ws openFile: path withApplication:@"BBEdit"];

     }
   }
    
  return nil;
}


@end
