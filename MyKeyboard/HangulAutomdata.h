//
//  HangulAutomdata.h
//  MyKeyboard
//
//  Created by Jinwoo Kim on 8/22/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HangulAutomdata : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (BOOL)isJamo:(NSString *)string;
+ (BOOL)isSyllables:(NSString *)string;
+ (NSString *)stringByDeletingLastElement:(NSString *)inputString;
+ (NSString *)string:(NSString *)inputString byInsertingElement:(NSString *)insertedString;
@end

NS_ASSUME_NONNULL_END
