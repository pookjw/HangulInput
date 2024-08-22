//
//  HAHangulAutomata+Private.h
//  MyApp
//
//  Created by Jinwoo Kim on 8/23/24.
//

#import <Foundation/Foundation.h>
#import <HangulAutomata/HAHangulAutomata.h>

NS_ASSUME_NONNULL_BEGIN

@interface HAHangulAutomata (Private) 
+ (unichar)jamoToFromCompatibilityJamo:(unichar)code;
@end

NS_ASSUME_NONNULL_END
