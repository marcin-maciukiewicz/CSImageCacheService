//
//  ImageCache.h
//  ImageCacheTest
//
//  Created by Adrian on 1/28/09.
//  Copyright 2009 Adrian Kosmaczewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSImageCacheDomain.h"

//#define MEMORY_CACHE_SIZE 100
//#define CACHE_FOLDER_NAME @"ImageCacheFolder"

// 10 days in seconds
//#define IMAGE_FILE_LIFETIME 864000.0

@interface CSImageCache : NSObject  {
	
@private
    NSMutableArray *_keyArray;
    NSMutableDictionary *_memoryCache;
    NSFileManager *_fileManager;
	id<CSImageCacheDomain> _domain;
}

@property(nonatomic,retain) NSMutableArray *_keyArray;
@property(nonatomic,retain) NSMutableDictionary *_memoryCache;
@property(nonatomic,retain) NSFileManager *_fileManager;
@property(nonatomic,retain) id<CSImageCacheDomain> _domain;

//+ (ImageCache *)sharedImageCache;
-(id)initWithDomain:(id<CSImageCacheDomain>)domain;

- (UIImage *)imageForKey:(NSString *)key;
- (BOOL)hasImageWithKey:(NSString *)key;

- (void)addImage:(UIImage *)image withKey:(NSString *)key keepInMemory:(BOOL)keepInMemory;

//- (BOOL)imageExistsInMemory:(NSString *)key;
//- (BOOL)imageExistsInDisk:(NSString *)key;
//- (NSUInteger)countImagesInMemory;
//- (NSUInteger)countImagesInDisk;
//- (void)removeImageWithKey:(NSString *)key;

- (void)removeAllImages;

- (void)removeAllImagesInMemory;

//- (void)removeOldImages;

@end
