// © 2010 Ralf Ebert
// Made available under Eclipse Public License v1.0, http://www.eclipse.org/legal/epl-v10.html

#import "CommonFilters.h"

#import "LogUtils.h"

id createMutableCopy(id obj) {
	if ([obj isKindOfClass:[NSArray class]]) {
		NSMutableArray *array = [NSMutableArray array];
		for(id item in obj) {
			[array addObject:createMutableCopy(item)];
		}
		return array;
	}
	if ([obj isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		for(id key in [dictionary keyEnumerator]) {
			[dictionary setValue:createMutableCopy([dictionary objectForKey:key]) forKey:key];
		}

		return [NSMutableDictionary dictionaryWithDictionary:obj];
	}
	return [[obj copy] autorelease];
}


#pragma mark -
#pragma mark SelectorFilter

@interface SelectorFilter : NSObject<ContentFilter> {
	NSString *fKeyPath;
	BOOL fMakeMutable;
}
@end

@implementation SelectorFilter

- (id) initWithKeyPath:(NSString *)keyPath makeMutable:(BOOL)makeMutable {
	self = [super init];
	if (self != nil) {
		fKeyPath = [keyPath copy];
		fMakeMutable = makeMutable;
	}
	return self;
}

- (void) addObject:(id)obj toList:(NSMutableArray *)array {
	if (fMakeMutable) {
		[array addObject:createMutableCopy(obj)];
	} else {
		[array addObject:obj];
	}
}

- (id) filter:(id)content {
	if ([content isKindOfClass:[NSArray class]]) {
		NSMutableArray *result = [NSMutableArray array];
		for(id obj in content) {
			id value = [obj valueForKeyPath:fKeyPath];
			if ([value isKindOfClass:[NSArray class]]) {
				for(id arrayItem in value) {
					[self addObject:arrayItem toList:result];
				}
			} else {
				[self addObject:value toList:result];
			}
		}
		return result;
	} else {
		return [content valueForKeyPath:fKeyPath];
	}
}

- (void) dealloc {
	[fKeyPath release];
	[super dealloc];
}

@end



#pragma mark -
#pragma mark MakeMutableFilter

@interface MakeMutableFilter : NSObject<ContentFilter>
@end

@implementation MakeMutableFilter

- (id) filter:(id)content {
	return createMutableCopy(content);
}

@end




#pragma mark -
#pragma mark BuildDictionaryFilter

@interface BuildDictionaryFilter : NSObject<ContentFilter> {
	NSString *fKeyPath;
}
@end

@implementation BuildDictionaryFilter

- (id) initWithKeyPath:(NSString *)keyPath {
	self = [super init];
	if (self != nil) {
		fKeyPath = [keyPath copy];
	}
	return self;
}

- (id) filter:(id)content {
	if (![content isKindOfClass:[NSArray class]]) {
		LogError(@"Input for %@ needs to be NSArray, but was %@", [self class], [content class]);
		return [NSDictionary dictionary];
	}

	NSArray *items = (NSArray *)content;
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[items count]];
	for(id item in items) {
		NSObject *key = [item valueForKeyPath:fKeyPath];
		[dict setObject:item forKey:key];
	}
	return dict;
}

- (void) dealloc {
	[fKeyPath release];
	[super dealloc];
}

@end


#pragma mark -
#pragma mark ImageFilter

@interface ImageFilter : NSObject<ContentFilter>
@end

@implementation ImageFilter

- (id) filter:(id)content {
	return [UIImage imageWithData:content];
}

@end


#pragma mark -
#pragma mark CommonFilters

@implementation CommonFilters

+ (id) filterForKeyPath:(NSString *)keyPath makeMutable:(BOOL)makeMutable {
	return [[[SelectorFilter alloc] initWithKeyPath:keyPath makeMutable:makeMutable] autorelease];
}

+ (id) filterForKeyPath:(NSString *)keyPath {
	return [[[SelectorFilter alloc] initWithKeyPath:keyPath makeMutable:NO] autorelease];
}

+ (id) filterForImage {
	return [[[ImageFilter alloc] init] autorelease];
}

// makes the content mutable. if content is a NSArray that contains NSArray/NSDictionary, these
// are made mutable as well
+ (id) filterForMutable {
	return [[[MakeMutableFilter alloc] init] autorelease];
}

+ (id) filterBuildDictionaryWithKeyPath:(NSString *)keyPath {
	return [[[BuildDictionaryFilter alloc] initWithKeyPath:keyPath] autorelease];
}

@end
