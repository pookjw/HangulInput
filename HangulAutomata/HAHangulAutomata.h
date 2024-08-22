//
//  HAHangulAutomdata.h
//  HangulAutomata
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HAHangulAutomata : NSObject 
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (NSString *)stringByDeletingLastElement:(NSString *)inputString NS_SWIFT_NAME(stringByDeletingLastElement(_:));
+ (NSString *)string:(NSString *)inputString byInsertingElement:(NSString *)insertedString NS_SWIFT_NAME(string(_:insertingElement:));
@end

NS_ASSUME_NONNULL_END
