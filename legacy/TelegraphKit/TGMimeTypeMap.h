/*
 * This is the source code of BTCchat for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import <Foundation/Foundation.h>

@interface TGMimeTypeMap : NSObject

+ (NSString *)mimeTypeForExtension:(NSString *)extension;
+ (NSString *)extensionForMimeType:(NSString *)mimeType;

@end
