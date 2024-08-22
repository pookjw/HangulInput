//
//  main.m
//  MyApp
//
//  Created by Jinwoo Kim on 8/21/24.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HangulAutomdata.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        assert([[HangulAutomdata stringByDeletingLastElement:@"갃"] isEqualToString:@"각"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"가"] characterAtIndex:0] == 0x1100);
//        assert([[HangulAutomdata stringByDeletingLastElement:@"가"] isEqualToString:@"ㄱ"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"와"] isEqualToString:@"오"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"낡"] isEqualToString:@"날"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"붧"] isEqualToString:@"붤"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"낭"] isEqualToString:@"나"]);
        assert([[HangulAutomdata stringByDeletingLastElement:@"와"] isEqualToString:@"오"]);
//        NSLog(@"%@", [HangulAutomdata string:@"ㄱ" byInsertingElement:@"ㅏ"]);
        
        NSLog(@"%@", [HangulAutomdata string:@"ㄱ" byInsertingElement:@"ㅏ"]);
//        assert([[HangulAutomdata string:@"ㄱ" byInsertingElement:"ㅏ"]])
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
