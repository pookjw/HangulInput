//
//  HangulAutomataTests.swift
//  HangulAutomdataTests
//
//  Created by Jinwoo Kim on 8/23/24.
//

import Foundation
import Testing
@testable import HangulAutomata
import HangulAutomata_Private

struct HangulAutomataTests {
    @Test func example() async throws {
        #expect(HAHangulAutomata.string("ㄷ", insertingElement: "ㄷ") == convert("ㄸ"))
        
        #expect(HAHangulAutomata.string("ㅇ", insertingElement: "ㅁ") == "ㅇㅁ")
        
        #expect(HAHangulAutomata.string("ㄱ", insertingElement: "ㅏ") == "가")
        #expect(HAHangulAutomata.string("ㅇ", insertingElement: "ㅔ") == "에")
        
        #expect(HAHangulAutomata.string("보", insertingElement: "ㅏ") == "봐")
        #expect(HAHangulAutomata.string("부", insertingElement: "ㅔ") == "붸")
        #expect(HAHangulAutomata.string("부", insertingElement: "ㅠ") == "부ㅠ")
        
        #expect(HAHangulAutomata.string("안", insertingElement: "ㅎ") == "않")
        #expect(HAHangulAutomata.string("악", insertingElement: "ㄱ") == "악ㄱ")
        #expect(HAHangulAutomata.string("알", insertingElement: "ㅎ") == "앓")
        
        #expect(HAHangulAutomata.string("a", insertingElement: "ㅎ") == "aㅎ")
        
        #expect(HAHangulAutomata.stringByDeletingLastElement("아") == convert("ㅇ"))
        #expect(HAHangulAutomata.stringByDeletingLastElement("ㅇ").isEmpty)
        #expect(HAHangulAutomata.stringByDeletingLastElement("안") == convert("아"))
        #expect(HAHangulAutomata.stringByDeletingLastElement("않") == convert("안"))
        #expect(HAHangulAutomata.stringByDeletingLastElement("워") == convert("우"))
        #expect(HAHangulAutomata.stringByDeletingLastElement("봐") == convert("보"))
    }
    
    private func convert(_ string: String) -> String {
        String(UnicodeScalar(HAHangulAutomata.jamoTo(fromCompatibilityJamo: unichar(string.utf16.first!)))!)
    }
}
