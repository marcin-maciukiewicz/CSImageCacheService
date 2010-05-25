//
//  ImageCacheDomain.h
//  Calineczka
//
//  Created by ciukes on 25/10/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CSImageCacheDomain <NSObject>

//-(NSString*)diskFolder;
-(NSUInteger)lifetime;
-(NSUInteger)memoryCacheSize;
-(void)removeAllImages;
-(BOOL)imageExists:(NSString*)key;
-(NSData*)getImageContents:(NSString*)key;
//-(void)removeImageFile:(NSString*)key;
-(void)addImage:(UIImage *)image withKey:(NSString *)key;

@end
