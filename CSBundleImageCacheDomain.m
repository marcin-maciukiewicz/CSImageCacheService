//
//  TableImageCacheDomain.m
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CSBundleImageCacheDomain.h"


@implementation CSBundleImageCacheDomain

- (NSString *)getCacheDirectoryName {
    return [[NSBundle mainBundle] resourcePath];
}

@end
