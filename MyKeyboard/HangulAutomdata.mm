//
//  HangulAutomdata.mm
//  MyKeyboard
//
//  Created by Jinwoo Kim on 8/22/24.
//

#import "HangulAutomdata.h"

@implementation HangulAutomdata

/*
 만약에
 초성 : ㄱㄴㄷ
 중성 : ㅏㅓㅗ
 종성 : (없음), ㄹㅁ
 
 이렇게만 한글이 있다고 가정하자. 참고로 초성, 중성, 종성은 각각 19, 21, 28개다.
 
 그러면 한글 유니코드는 아래와 같다.
 
 ㄱ ㄱ ㄱ ㄱ ㄱ ㄱ ㄱ ㄱ ㄱ
 ㅏ ㅓ ㅗ ㅏ ㅓ ㅗ ㅏ ㅓ ㅗ
        ㄹ ㄹ ㄹ ㅁ ㅁ ㅁ
 
 '가'는 0xAC00 이며 여기서 1씩 더해가는 원리다.
 따라서 종성은 (대상 - 0xAC00) % 28로 하면 알 수 있으며
 중성은 (대상 - 0xAC00) / 28 % 21을 하면 얻을 수 있고
 초성은 (대상 - 0xAC00) / 28 / 21을 하면 얻을 수 있다.
 */

// 초성 얻기
+ (NSString * _Nullable)initialConsonantFromString:(NSString *)string {
    if (string.length == 0) return nil;
    
    unichar code = [string characterAtIndex:string.length - 1];
    unichar result = 0x1100 + ((code - 0xAC00) / 28 / 21);
    
    return [NSString stringWithCharacters:&result length:1];
}

// 중성 얻기
+ (NSString * _Nullable)vowelFromString:(NSString *)string {
    if (string.length == 0) return nil;
    
    unichar code = [string characterAtIndex:string.length - 1];
    unichar result = 0x1161 + ((code - 0xAC00) / 28 % 21);
    
    return [NSString stringWithCharacters:&result length:1];
}

// 종성 얻기
+ (NSString * _Nullable)finalConsonantFromString:(NSString *)string {
    if (string.length == 0) return nil;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    if ((code - 0xAC00) % 28 == 0) return nil;
    
    unichar result = 0x11A8 + ((code - 0xAC00) % 28) - 1;
    
    return [NSString stringWithCharacters:&result length:1];
}

+ (BOOL)isConsonant:(NSString *)string {
    if (string.length == 0) return NO;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    return (code >= 0x1161) && (code <= 0x1112);
}

+ (BOOL)isJamo:(NSString *)string {
    if (string.length == 0) return NO;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    return (code <= 0x11FF) && (code >= 0x1100);
}

+ (BOOL)isSyllables:(NSString *)string {
    if (string.length == 0) return NO;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    return (code <= 0xD7A3) && (code >= 0xAC00);
}

+ (NSString *)stringByDeletingLastElement:(NSString *)inputString {
    assert(inputString.length == 1);
    assert([HangulAutomdata isSyllables:inputString]);
    
    NSString *initialConsonant = [HangulAutomdata initialConsonantFromString:inputString];
    assert(initialConsonant != nil);
    
    NSString *vowel = [HangulAutomdata vowelFromString:inputString];
    
    if (vowel == nil) {
        return @"";
    }
    
    NSString *finalConsonant = [HangulAutomdata finalConsonantFromString:inputString];
    
    if (finalConsonant == nil) {
        unichar initialConsonantUnicode = [initialConsonant characterAtIndex:initialConsonant.length - 1];
        unichar vowelUnicode = [vowel characterAtIndex:vowel.length - 1];
        
        BOOL deleteVowel;
        if (vowelUnicode >= 0x116A && vowelUnicode <= 0x116C) {
            vowelUnicode = 0x1169;
            deleteVowel = NO;
        } else if (vowelUnicode >= 0x116F && vowelUnicode <= 0x1171) {
            vowelUnicode = 0x116E;
            deleteVowel = NO;
        } else if (vowelUnicode == 0x1174) {
            vowelUnicode = 0x1173;
            deleteVowel = NO;
        } else {
            deleteVowel = YES;
        }
        
        if (deleteVowel) {
            return initialConsonant;
        } else {
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28);
            
            return [NSString stringWithCharacters:&result length:1];
        }
    } else {
        unichar initialConsonantUnicode = [initialConsonant characterAtIndex:initialConsonant.length - 1];
        unichar vowelUnicode = [vowel characterAtIndex:vowel.length - 1];
        
        unichar finalConsonantUnicode = [finalConsonant characterAtIndex:finalConsonant.length - 1];
        BOOL deleteFinalConsonant;
        if (finalConsonantUnicode == 0x11AA) {
            // ᆪ
            finalConsonantUnicode = 0x11A8;
            deleteFinalConsonant = NO;
        } else if (finalConsonantUnicode >= 0x11AC && finalConsonantUnicode <= 0x11AD) {
            // ᆬᆭ
            finalConsonantUnicode = 0x11AB;
            deleteFinalConsonant = NO;
        } else if (finalConsonantUnicode >= 0x11B0 && finalConsonantUnicode <= 0x11B6) {
            // ᆰᆱᆲᆳᆴᆵᆶ
            finalConsonantUnicode = 0x11AF;
            deleteFinalConsonant = NO;
        } else if (finalConsonantUnicode == 0x11B9) {
            // ᆹ
            finalConsonantUnicode = 0x11B8;
            deleteFinalConsonant = NO;
        } else {
            deleteFinalConsonant = YES;
        }
        
        unichar result;
        if (deleteFinalConsonant) {
            result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28);
        } else {
            result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (finalConsonantUnicode - 0x11A8 + 1);
        }
        
        return [NSString stringWithCharacters:&result length:1];
    }
}

+ (NSString *)string:(NSString *)inputString byInsertingElement:(NSString *)insertedString {
    assert(inputString.length == 1);
    assert(insertedString.length == 1);
    
    NSString *initialConsonant = [HangulAutomdata initialConsonantFromString:inputString];
    assert(initialConsonant != nil);
    
    NSString *vowel = [HangulAutomdata vowelFromString:inputString];
    
    if (vowel == nil) {
        unichar insertedStringUnicode = [insertedString characterAtIndex:0];
        
        if (insertedStringUnicode >= 0x1161 && insertedStringUnicode <= 0x1175) {
            unichar initialConsonantUnicode = [initialConsonant characterAtIndex:0];
            
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((insertedStringUnicode - 0x1161) * 28);
            
            return [NSString stringWithCharacters:&result length:1];
        } else {
            return [inputString stringByAppendingString:insertedString];
        }
    }
    
    abort();
}

@end
