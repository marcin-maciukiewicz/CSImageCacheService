//
//  ImageCacheFactory.h
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSImageCache.h"
#import "CSImageCacheDomain.h"

enum {
	ImageCacheDomainIdGeneral,
	ImageCacheDomainIdBundle,
} typedef ImageCacheDomainId;


@interface CSImageCacheFactory : NSObject {
	CSImageCache *_generalCache;
//	ImageCache *_avatarCache;
	CSImageCache *_bundleCache;
}

@property(nonatomic,retain) CSImageCache *_generalCache;
//@property(nonatomic,retain) ImageCache *_avatarCache;
@property(nonatomic,retain) CSImageCache *_bundleCache;

+ (CSImageCacheFactory*)sharedImageCache;

-(CSImageCache*)newCacheWithDomain:(id<CSImageCacheDomain>)domain;
-(CSImageCache*)getCacheWithDomainId:(ImageCacheDomainId)domainId;
-(void)removeAllImages;
-(void)removeAllImagesInMemory;
-(void)didReceiveMemoryWarning;

+(UIImage*)bundleImageNamed:(NSString*)bundleImageFileName;

@end
