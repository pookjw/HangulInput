//
//  main.m
//  MyScript2
//
//  Created by Jinwoo Kim on 8/22/24.
//

#import <Foundation/Foundation.h>
#import "HangulAutomdata.h"

int main(int argc, const char * argv[]) {
//    assert([[HangulAutomdata stringByDeletingLastElement:@"갃"] isEqualToString:@"각"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"가"] characterAtIndex:0] == 0x1100);
////        assert([[HangulAutomdata stringByDeletingLastElement:@"가"] isEqualToString:@"ㄱ"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"와"] isEqualToString:@"오"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"낡"] isEqualToString:@"날"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"붧"] isEqualToString:@"붤"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"낭"] isEqualToString:@"나"]);
//    assert([[HangulAutomdata stringByDeletingLastElement:@"와"] isEqualToString:@"오"]);
//        NSLog(@"%@", [HangulAutomdata string:@"ㄱ" byInsertingElement:@"ㅏ"]);
    
    NSLog(@"%@", [HangulAutomdata string:@"안" byInsertingElement:@"ㅎ"]);
    return 0;
}
