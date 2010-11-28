// © 2010 Ralf Ebert
// Made available under Simplified BSD License, http://www.opensource.org/licenses/bsd-license.php

#import "ContentProviderPlaceholder.h"

#import "BoxCell.h"

@implementation ContentProviderPlaceholder

- (id) initWithController:(BoxTableViewController *)controller cellFactorySelector:(SEL)cellFactorySelector contentProvider:(IPContentProvider *)contentProvider {
	self = [super init];
	if (self != nil) {
		fController = controller; // weak
		fCellFactorySelector = cellFactorySelector;
		fContentProvider = [contentProvider retain];
		[fContentProvider addObserver:self forKeyPath:@"content" options:NSKeyValueObservingOptionNew context:nil];
		fContent = [fContentProvider.content retain];
		[fContentProvider requestContentIfEmpty];
	}
	return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[fContent release];
	fContent = [fContentProvider.content retain];
	[fController.tableView reloadData];
}

- (int) count {
	return (fContent == nil) ? 1 : [fContent count];
}

- (id) objectAtIndex:(int) index {
	if (fContent == nil) {
		BoxCell *cell = [[BoxCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		indicator.frame = CGRectMake(150.0, 13.0, 40.0, 40.0);
		[indicator startAnimating];
		[indicator sizeToFit];
		[cell addSubview:indicator];
		[indicator release];
		[cell autorelease];
		return cell;
	}
	
	return [fController performSelector:fCellFactorySelector withObject:[fContent objectAtIndex:index]];
}

- (void) dealloc {
	[fContentProvider removeObserver:self forKeyPath:@"content"];
	[fContentProvider release];
	[fContent release];
	[super dealloc];
}

@end