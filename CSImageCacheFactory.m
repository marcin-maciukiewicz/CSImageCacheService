//
//  ImageCacheFactory.m
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSImageCacheFactory.h"
#import "GTMObjectSingleton.h"
#import "CSGeneralImageCacheDomain.h"
#import "CSBundleImageCacheDomain.h"

@implementation CSImageCacheFactory

@synthesize _generalCache;
//@synthesize _avatarCache;
@synthesize _bundleCache;

GTMOBJECT_SINGLETON_BOILERPLATE(CSImageCacheFactory, sharedImageCache)

-(CSImageCache*)newCacheWithDomain:(id<CSImageCacheDomain>)domain {
	return [[CSImageCache alloc] initWithDomain:domain];
}

-(CSImageCache*)getCacheWithDomainId:(ImageCacheDomainId)domainId {
	switch(domainId){
		case ImageCacheDomainIdGeneral:{
			if(!_generalCache){
				id<CSImageCacheDomain> generalDomain=[[CSGeneralImageCacheDomain alloc] init];
				self._generalCache=[[CSImageCache alloc] initWithDomain:generalDomain];
				[generalDomain release];
			}
			return _generalCache;
			break;
		}
		/*case ImageCacheDomainIdAvatar:{
			if(!_avatarCache){
				id<ImageCacheDomain> avatarDomain=[[AvatarImageCacheDomain alloc] init];
				self._avatarCache=[[ImageCache alloc] initWithDomain:avatarDomain];
				[avatarDomain release];
			}
			return _avatarCache;
			break;
		}*/
		case ImageCacheDomainIdBundle: {
			if(!_bundleCache){
				id<CSImageCacheDomain> tableDomain=[[CSBundleImageCacheDomain alloc] init];
				self._bundleCache=[[CSImageCache alloc] initWithDomain:tableDomain];
				[tableDomain release];
			}
			return _bundleCache;
			break;
		}
	}
	
	return nil;
}

-(void)dealloc {
	[_generalCache release];
//	[_avatarCache release];
	[_bundleCache release];
	
	[super dealloc];
}

+(UIImage*)bundleImageNamed:(NSString*)bundleImageFileName {
	CSImageCache *bundleImagesCache=[[CSImageCacheFactory sharedImageCache] getCacheWithDomainId:ImageCacheDomainIdBundle];
	UIImage *result=[bundleImagesCache imageForKey:bundleImageFileName];
	return result;
}

-(void)removeAllImagesInMemory {
	[_generalCache removeAllImagesInMemory];
//	[_avatarCache removeAllImagesInMemory];
	[_bundleCache removeAllImagesInMemory];		
}

-(void)removeAllImages {
	[_generalCache removeAllImages];
//	[_avatarCache removeAllImages];
	[_bundleCache removeAllImages];	
}

-(void)didReceiveMemoryWarning {
	[self removeAllImagesInMemory];
}

@end
