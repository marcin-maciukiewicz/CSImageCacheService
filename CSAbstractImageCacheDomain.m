//
//  AbstractImageCacheDomain.m
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSAbstractImageCacheDomain.h"
#define CACHE_FOLDER_NAME @"Cache"

@implementation CSAbstractImageCacheDomain

@synthesize _fileManager;

-(id)init {
	self._fileManager=[NSFileManager defaultManager];
	
	return self;
}
-(NSString*)diskFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"ImageCacheFolder_General"];
    return cacheDirectoryName;
}

-(NSUInteger)lifetime {
	return IMAGE_FILE_LIFETIME;
}

-(NSUInteger)memoryCacheSize {
	return MEMORY_CACHE_SIZE;
}

-(void)removeAllImages {
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	@try{
		NSString *cacheDirectoryName = [self diskFolder];
		NSError *error = nil;
		NSString *suffix=@"deleteme";
		NSString *dstPath=[[NSString alloc] initWithFormat:@"%@-%@",cacheDirectoryName,suffix];
		NSFileManager *fileManager=[NSFileManager defaultManager];
		[fileManager moveItemAtPath:cacheDirectoryName toPath:dstPath error:&error];
		[error release];	error=nil;
		[fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:&error];
		[error release];	error=nil;
		// ignore the "move"command result
		// important is if the directory exists; it could be created before - don't care.
		if([fileManager isDeletableFileAtPath:dstPath]){
			[fileManager removeItemAtPath:dstPath error:&error];
			DebugLog(@"removed: [%@] error:[%@]",dstPath,error);
			[error release];error=nil;
		}
		[dstPath release];
	}@catch (NSException *exception) {
		NSLog(@"Caught [%@:%@]",exception.name, exception.reason);
	}

	@try{	
		// you should use drain instead of release.
		[pool drain];
	}@catch (NSException *exception) {
		NSLog(@"Caught [%@:%@]",exception.name, exception.reason);
	}
 
}

-(BOOL)imageExists:(NSString*)key {
	NSString *fileName = [self getFileNameForKey:key];
    return [_fileManager fileExistsAtPath:fileName];
}

-(NSData*)getImageContents:(NSString*)key {
	NSString *fileName = [self getFileNameForKey:key];
	NSData *result=[NSData dataWithContentsOfFile:fileName];
	return result;
}

-(void)addImage:(UIImage *)image withKey:(NSString *)key {
        NSString *fileName = [self getFileNameForKey:key];
        [UIImagePNGRepresentation(image) writeToFile:fileName atomically:YES];
}

- (NSString *)getCacheDirectoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:[self cacheFolderName]];
    return cacheDirectoryName;
}

-(NSString*)cacheFolderName {
	return CACHE_FOLDER_NAME;
}

- (NSString *)getFileNameForKey:(NSString *)key {
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSString *fileName = [cacheDirectoryName stringByAppendingPathComponent:key];
    return fileName;
}

-(void)dealloc {
	[_fileManager release];
	
	[super dealloc];
}

@end
