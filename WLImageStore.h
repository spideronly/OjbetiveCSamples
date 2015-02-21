//
//  WLImageStore.h
//  Wishlist
//
//  Created by Scott Leberknight on 10/8/12.
//  Copyright (c) 2012 Scott Leberknight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WLImageStore : NSObject

+(WLImageStore *)defaultStore;
+(CGRect)rectForImage:(UIImage *)image withSize:(CGSize)size;

-(NSString *)imagePathForKey:(NSString *)key;
-(void)setImage:(UIImage *)img forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

@end
