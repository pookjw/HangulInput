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
    if (string.length == 0) return nil;\
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    if ([HangulAutomdata jamoToFromCompatibilityJamo:code] >= 0x1100 && [HangulAutomdata jamoToFromCompatibilityJamo:code] <= 0x1112) {
        return [NSString stringWithCharacters:&code length:1];
    }
    
    if (![HangulAutomdata isSyllables:string]) {
        return nil;
    }
    
    unichar result = 0x1100 + ((code - 0xAC00) / 28 / 21);
    result = [HangulAutomdata jamoToFromCompatibilityJamo:result];
    
    return [NSString stringWithCharacters:&result length:1];
}

// 중성 얻기
+ (NSString * _Nullable)vowelFromString:(NSString *)string {
    if (string.length == 0) return nil;
    if (![HangulAutomdata isSyllables:string]) return nil;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    if ([HangulAutomdata jamoToFromCompatibilityJamo:code] >= 0x1161 && [HangulAutomdata jamoToFromCompatibilityJamo:code] <= 0x1175) {
        return [NSString stringWithCharacters:&code length:1];
    }
    
    if (![HangulAutomdata isSyllables:string]) {
        return nil;
    }
    
    unichar result = 0x1161 + ((code - 0xAC00) / 28 % 21);
    result = [HangulAutomdata jamoToFromCompatibilityJamo:result];
    
    return [NSString stringWithCharacters:&result length:1];
}

// 종성 얻기
+ (NSString * _Nullable)finalConsonantFromString:(NSString *)string {
    if (string.length == 0) return nil;
    if (![HangulAutomdata isSyllables:string]) return nil;
    
    unichar code = [string characterAtIndex:string.length - 1];
    
    if ([HangulAutomdata jamoToFromCompatibilityJamo:code] >= 0x11A8 && [HangulAutomdata jamoToFromCompatibilityJamo:code] <= 0x11C2) {
        return [NSString stringWithCharacters:&code length:1];
    }
    
    if (![HangulAutomdata isSyllables:string]) {
        return nil;
    }
    
    if ((code - 0xAC00) % 28 == 0) return nil;
    
    unichar result = 0x11A8 + ((code - 0xAC00) % 28) - 1;
    result = [HangulAutomdata jamoToFromCompatibilityJamo:result];
    
    return [NSString stringWithCharacters:&result length:1];
}

+ (unichar)jamoToFromCompatibilityJamo:(unichar)code {
    if (code == 0x3131) {
        code = 0x1100;  // ㄱ
    } else if (code == 0x3132) {
        code = 0x1101;  // ㄲ
    } else if (code == 0x3133) {
        code = 0x11AA;  // ㄳ
    } else if (code == 0x3134) {
        code = 0x1102;  // ㄴ
    } else if (code == 0x3135) {
        code = 0x11AC;  // ㄵ
    } else if (code == 0x3136) {
        code = 0x11AD;  // ㄶ
    } else if (code == 0x3137) {
        code = 0x1103;  // ㄷ
    } else if (code == 0x3138) {
        code = 0x1104;  // ㄸ
    } else if (code == 0x3139) {
        code = 0x1105;  // ㄹ
    } else if (code == 0x313A) {
        code = 0x11B0;  // ㄺ
    } else if (code == 0x313B) {
        code = 0x11B1;  // ㄻ
    } else if (code == 0x313C) {
        code = 0x11B2;  // ㄼ
    } else if (code == 0x313D) {
        code = 0x11B3;  // ㄽ
    } else if (code == 0x313E) {
        code = 0x11B4;  // ㄾ
    } else if (code == 0x313F) {
        code = 0x11B5;  // ㄿ
    } else if (code == 0x3140) {
        code = 0x11B6;  // ㅀ
    } else if (code == 0x3141) {
        code = 0x1106;  // ㅁ
    } else if (code == 0x3142) {
        code = 0x1107;  // ㅂ
    } else if (code == 0x3143) {
        code = 0x1108;  // ㅃ
    } else if (code == 0x3144) {
        code = 0x1121;  // ㅄ
    } else if (code == 0x3145) {
        code = 0x1109;  // ㅅ
    } else if (code == 0x3146) {
        code = 0x110A;  // ㅆ
    } else if (code == 0x3147) {
        code = 0x110B;  // ㅇ
    } else if (code == 0x3148) {
        code = 0x110C;  // ㅈ
    } else if (code == 0x3149) {
        code = 0x110D;  // ㅉ
    } else if (code == 0x314A) {
        code = 0x110E;  // ㅊ
    } else if (code == 0x314B) {
        code = 0x110F;  // ㅋ
    } else if (code == 0x314C) {
        code = 0x1110;  // ㅌ
    } else if (code == 0x314D) {
        code = 0x1111;  // ㅍ
    } else if (code == 0x314E) {
        code = 0x1112;  // ㅎ
    } else if (code == 0x314F) {
        code = 0x1161;  // ㅏ
    } else if (code == 0x3150) {
        code = 0x1162;  // ㅐ
    } else if (code == 0x3151) {
        code = 0x1163;  // ㅑ
    } else if (code == 0x3152) {
        code = 0x1164;  // ㅒ
    } else if (code == 0x3153) {
        code = 0x1165;  // ㅓ
    } else if (code == 0x3154) {
        code = 0x1166;  // ㅔ
    } else if (code == 0x3155) {
        code = 0x1167;  // ㅕ
    } else if (code == 0x3156) {
        code = 0x1168;  // ㅖ
    } else if (code == 0x3157) {
        code = 0x1169;  // ㅗ
    } else if (code == 0x3158) {
        code = 0x116A;  // ㅘ
    } else if (code == 0x3159) {
        code = 0x116B;  // ㅙ
    } else if (code == 0x315A) {
        code = 0x116C;  // ㅚ
    } else if (code == 0x315B) {
        code = 0x116D;  // ㅛ
    } else if (code == 0x315C) {
        code = 0x116E;  // ㅜ
    } else if (code == 0x315D) {
        code = 0x116F;  // ㅝ
    } else if (code == 0x315E) {
        code = 0x1170;  // ㅞ
    } else if (code == 0x315F) {
        code = 0x1171;  // ㅟ
    } else if (code == 0x3160) {
        code = 0x1172;  // ㅠ
    } else if (code == 0x3161) {
        code = 0x1173;  // ㅡ
    } else if (code == 0x3162) {
        code = 0x1174;  // ㅢ
    } else if (code == 0x3163) {
        code = 0x1175;  // ㅣ
    }
    
    return code;
}

+ (unichar)finalJamoFromInitialJamo:(unichar)code {
    if (code == 0x1100) {
        code = 0x11A8;  // ㄱ -> ㄱ
    } else if (code == 0x1101) {
        code = 0x11A9;  // ㄲ -> ㄲ
    } else if (code == 0x1102) {
        code = 0x11AB;  // ㄴ -> ㄴ
    } else if (code == 0x1103) {
        code = 0x11AE;  // ㄷ -> ㄷ
    } else if (code == 0x1104) {
        code = 0x11AF;  // ㄸ -> ㄹ
    } else if (code == 0x1105) {
        code = 0x11AF;  // ㄹ -> ㄹ
    } else if (code == 0x1106) {
        code = 0x11B7;  // ㅁ -> ㅁ
    } else if (code == 0x1107) {
        code = 0x11B8;  // ㅂ -> ㅂ
    } else if (code == 0x1109) {
        code = 0x11BA;  // ㅅ -> ㅅ
    } else if (code == 0x110A) {
        code = 0x11BB;  // ㅆ -> ㅆ
    } else if (code == 0x110B) {
        code = 0x11BC;  // ㅇ -> ㅇ
    } else if (code == 0x110C) {
        code = 0x11BD;  // ㅈ -> ㅈ
    } else if (code == 0x110E) {
        code = 0x11BF;  // ㅊ -> ㅋ
    } else if (code == 0x110F) {
        code = 0x11C0;  // ㅋ -> ㅌ
    } else if (code == 0x1110) {
        code = 0x11C1;  // ㅌ -> ㅍ
    } else if (code == 0x1111) {
        code = 0x11C2;  // ㅍ -> ㅎ
    } else if (code == 0x1112) {
        code = 0x11C2;  // ㅎ -> ㅎ
    }
    
    return code;
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
    
    if (initialConsonant == nil) {
        return [inputString stringByAppendingString:insertedString];
    }
    
    //
    
    NSString *vowel = [HangulAutomdata vowelFromString:inputString];
    
    if (vowel == nil) {
        unichar insertedStringUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[insertedString characterAtIndex:0]];
        
        if (insertedStringUnicode >= 0x1161 && insertedStringUnicode <= 0x1175) {
            // ㄱ + ㅏ = 가
            unichar initialConsonantUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[initialConsonant characterAtIndex:0]];
            
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((insertedStringUnicode - 0x1161) * 28);
            
            return [NSString stringWithCharacters:&result length:1];
        } else {
            return [inputString stringByAppendingString:insertedString];
        }
    }
    
    //
    
    NSString *finalConsonantFromString = [HangulAutomdata finalConsonantFromString:inputString];
    
    if (finalConsonantFromString == nil) {
        unichar initialConsonantUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[initialConsonant characterAtIndex:0]];
        unichar vowelUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[vowel characterAtIndex:0]];
        unichar insertedStringUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[insertedString characterAtIndex:0]];
        
        if (vowelUnicode == 0x1169 && insertedStringUnicode == 0x1161) {
            // ㅗ + ㅏ = ㅘ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x116A - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x1169 && insertedStringUnicode == 0x1162) {
            // ㅗ + ㅐ = ㅙ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x116B - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x1169 && insertedStringUnicode == 0x1175) {
            // ㅗ + ㅣ = ㅚ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x116C - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x116E && insertedStringUnicode == 0x1165) {
            // ㅜ + ㅓ = ㅝ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x116F - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x116E && insertedStringUnicode == 0x1166) {
            // ㅜ + ㅔ = ㅞ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x1170 - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x116E && insertedStringUnicode == 0x1175) {
            // ㅜ + ㅣ = ㅟ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x1171 - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if (vowelUnicode == 0x1173 && insertedStringUnicode == 0x1175) {
            // ㅡ + ㅣ = ㅢ
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((0x1174 - 0x1161) * 28);
            return [NSString stringWithCharacters:&result length:1];
        } else if ([HangulAutomdata finalJamoFromInitialJamo:insertedStringUnicode] >= 0x11A8 && [HangulAutomdata finalJamoFromInitialJamo:insertedStringUnicode] <= 0x11C2) {
            unichar result = 0xAC00 + ((initialConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + ([HangulAutomdata finalJamoFromInitialJamo:insertedStringUnicode] - 0x11A8 + 1);
            return [NSString stringWithCharacters:&result length:1];
        } else {
            return [inputString stringByAppendingString:insertedString];
        }
    }
    
    //
    
    unichar initialConsonantUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[initialConsonant characterAtIndex:0]];
    unichar vowelUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[vowel characterAtIndex:0]];
    unichar finalConsonantUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[finalConsonantFromString characterAtIndex:0]];
    unichar insertedStringUnicode = [HangulAutomdata jamoToFromCompatibilityJamo:[insertedString characterAtIndex:0]];
    
    if (finalConsonantUnicode == 0x1100 && (insertedStringUnicode == 0x1109 || insertedStringUnicode == 0x11BA)) {
        // ㄱ + ㅅ = ᆪ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11AA - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1102 && (insertedStringUnicode == 0x110C || insertedStringUnicode == 0x11BD)) {
        // ㄴ + ㅈ = ᆬ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11AC - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1102 && (insertedStringUnicode == 0x1112 || insertedStringUnicode == 0x11C2)) {
        // ㄴ + ㅎ = ᆭ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11AD - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1100 || insertedStringUnicode == 0x11A8)) {
        // ㄹ + ㄱ = ᆰ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B0 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1106 || insertedStringUnicode == 0x11B7)) {
        // ㄹ + ㅁ = ᆱ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B1 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1107 || insertedStringUnicode == 0x11B8)) {
        // ㄹ + ㅂ = ᆲ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B2 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1109 || insertedStringUnicode == 0x11BA)) {
        // ㄹ + ㅅ = ᆳ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B3 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1110 || insertedStringUnicode == 0x11C0)) {
        // ㄹ + ㅌ = ᆴ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B4 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1111 || insertedStringUnicode == 0x11C1)) {
        // ㄹ + ㅍ = ᆵ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B5 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1105 && (insertedStringUnicode == 0x1112 || insertedStringUnicode == 0x11C2)) {
        // ㄹ + ㅎ = ᆶ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B6 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    } else if (finalConsonantUnicode == 0x1107 && (insertedStringUnicode == 0x1109 || insertedStringUnicode == 0x11BA)) {
        // ㅂ + ㅅ = ᆹ
        unichar result = 0xAC00 + ((finalConsonantUnicode - 0x1100) * 21 * 28) + ((vowelUnicode - 0x1161) * 28) + (0x11B9 - 0x11A8 + 1);
        return [NSString stringWithCharacters:&result length:1];
    }
    
    //
    
    return [inputString stringByAppendingString:insertedString];
}

@end
