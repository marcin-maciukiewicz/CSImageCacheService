//
//  ImageCache.m
//  ImageCacheTest
//
//  Created by Adrian on 1/28/09.
//  Copyright 2009 Adrian Kosmaczewski. All rights reserved.
//

#import "CSImageCache.h"
#import "GTMObjectSingleton.h"

@interface CSImageCache(Private)

- (void)addImageToMemoryCache:(UIImage *)image withKey:(NSString *)key;
- (NSString *)getCacheDirectoryName;
- (NSString *)getFileNameForKey:(NSString *)key;
- (BOOL)imageExistsInMemory:(NSString *)key;
- (BOOL)imageExistsInDisk:(NSString *)key;

@end


@implementation CSImageCache

@synthesize _keyArray;
@synthesize _memoryCache;
@synthesize _fileManager;
@synthesize _domain;

-(id)initWithDomain:(id<CSImageCacheDomain>) domain {
    if (self = [super init]){
		self._domain=domain;
        self._keyArray = [[NSMutableArray alloc] initWithCapacity:[domain memoryCacheSize]];
        self._memoryCache = [[NSMutableDictionary alloc] initWithCapacity:[domain memoryCacheSize]];
        self._fileManager = [NSFileManager defaultManager];

        /*
        NSString *cacheDirectoryName = [domain diskFolder];//[self getCacheDirectoryName];
        BOOL isDirectory = NO;
        BOOL folderExists = [_fileManager fileExistsAtPath:cacheDirectoryName isDirectory:&isDirectory] && isDirectory;

        if (!folderExists) {
            NSError *error = nil;
            [_fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:&error];
            [error release];
        }
		 */
    }
    return self;
}

- (void)dealloc
{
    [_keyArray release];
    [_memoryCache release];
    _keyArray = nil;
    _memoryCache = nil;
//    _fileManager = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *image = [_memoryCache objectForKey:key];
    if (image == nil && [_domain imageExists:key])
    {
//        NSString *fileName = 
        NSData *data = [_domain getImageContents:key];//[NSData dataWithContentsOfFile:fileName];
        image = [[[UIImage alloc] initWithData:data] autorelease];
        [self addImageToMemoryCache:image withKey:key];
    }
    return image;
}

- (BOOL)hasImageWithKey:(NSString *)key {
    BOOL exists = [self imageExistsInMemory:key];
    if (!exists) {
        exists = [_domain imageExists:key];
    }
    return exists;
}

- (void)removeImageWithKey:(NSString *)key {
    if ([self imageExistsInMemory:key])
    {
        NSUInteger index = [_keyArray indexOfObject:key];
        [_keyArray removeObjectAtIndex:index];
        [_memoryCache removeObjectForKey:key];
    }

	//[_domain removeImageFile:key];
//    if ([_domain imageExists:key])
//    {
//        NSError *error = nil;
//        NSString *fileName = [self getFileNameForKey:key];
//        [_fileManager removeItemAtPath:fileName error:&error];
//        [error release];
//    }
}

- (void)removeAllImages {
	[_memoryCache removeAllObjects];
	[_domain removeAllImages];
}

- (void)removeAllImagesInMemory {
    [_memoryCache removeAllObjects];
}

/*
- (void)removeOldImages{
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSArray *items = [_fileManager directoryContentsAtPath:cacheDirectoryName];
    for (NSString *item in items)
    {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:item];
        NSDictionary *attributes = [_fileManager attributesOfItemAtPath:path error:nil];
        NSDate *creationDate = [attributes valueForKey:NSFileCreationDate];
        if (abs([creationDate timeIntervalSinceNow]) > [_domain lifetime]) {
            NSError *error = nil;
            [_fileManager removeItemAtPath:path error:&error];
			DebugLog(@"removed: [%@] error:[%@]",path,error);
        }
    }
}
 */

- (BOOL)imageExistsInMemory:(NSString *)key
{
    return ([_memoryCache objectForKey:key] != nil);
}

- (BOOL)imageExistsInDomain:(NSString *)key {
//    NSString *fileName = [self getFileNameForKey:key];
    return [_domain imageExists:key];//[_fileManager fileExistsAtPath:fileName];
}

- (NSUInteger)countImagesInMemory {
    return [_memoryCache count];
}

/*
- (NSUInteger)countImagesInDomain
{
//    NSString *cacheDirectoryName = [self getCacheDirectoryName];
//    NSArray *items = [_fileManager directoryContentsAtPath:cacheDirectoryName];
    return [_domain imagesCount];
}
*/

- (void)addImage:(UIImage *)image withKey:(NSString *)key keepInMemory:(BOOL)keepInMemory {
    if (image != nil && key != nil){
		if(keepInMemory) {
			[self addImageToMemoryCache:image withKey:key];
		}
		[_domain addImage:image withKey:key];		
    }
}
- (void)addImageToMemoryCache:(UIImage *)image withKey:(NSString *)key {
    // Add the object to the memory cache for faster retrieval next time
    [_memoryCache setObject:image forKey:key];
    
    // Add the key at the beginning of the _keyArray
    [_keyArray insertObject:key atIndex:0];

    // Remove the first object added to the memory cache
    if ([_keyArray count] > [_domain memoryCacheSize])
    {
        // This is the "raison d'etre" de _keyArray:
        // we use it to keep track of the last object
        // in it (that is, the first we've inserted), 
        // so that the total size of objects in memory
        // is never higher than MEMORY_CACHE_SIZE.
        NSString *lastObjectKey = [_keyArray lastObject];
        [_memoryCache removeObjectForKey:lastObjectKey];
        [_keyArray removeLastObject];
    }    
}

/*
- (NSString *)getCacheDirectoryName {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:CACHE_FOLDER_NAME];
//    return cacheDirectoryName;
	return [_domain diskFolder];
}
 */

/*
- (NSString *)getFileNameForKey:(NSString *)key
{
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSString *fileName = [cacheDirectoryName stringByAppendingPathComponent:key];
    return fileName;
}
 */

@end
