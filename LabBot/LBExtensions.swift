//
//  File.swift
//  LabBot
//
//  Created by Lee Walsh on 9/04/2015.
//  Copyright (c) 2015 Lee David Walsh. All rights reserved.
//  This sofware is licensed under the The MIT License (MIT)
//  See: https://github.com/Tanglo/LabBot/blob/master/LICENSE.md
//

import Foundation

extension String {
    
    /**
        Increments the string by the specificed amount.

        - parameter increment: How much to incrememt the string by.
        - parameter floor: The value to start from when a character overflows (the equivalent to zero in numbers).
        - parameter ceiling: The overflow value.  When a character gets to this value it resets to the floor and the next more significnat character increments by one.
        - returns: The incrememted String.
    */
    public func incrementBy(increment: Int, floor: Character, ceiling: Character) -> String {
        let lastChar = self.substringFromIndex(self.endIndex.predecessor())
        var remString = self.substringToIndex(self.endIndex.predecessor())
        let lastCharUnicode = lastChar.unicodeScalars[lastChar.unicodeScalars.startIndex].value
        let newUnicode = lastCharUnicode + UInt32(increment)
        var newLastChar = Character(UnicodeScalar(newUnicode))
        let ceilingUnicode = String(ceiling).unicodeScalars[lastChar.unicodeScalars.startIndex].value
        if newUnicode > ceilingUnicode {
            var charOverflow = newUnicode-ceilingUnicode
            let floorUnicode = String(floor).unicodeScalars[lastChar.unicodeScalars.startIndex].value
            let unicodeRange = (ceilingUnicode + 1) - floorUnicode
            var numOverflows = 1
            while charOverflow > unicodeRange {
                numOverflows++
                charOverflow -= unicodeRange
            }
            newLastChar = Character(UnicodeScalar(floorUnicode+charOverflow-1))
            remString = remString.incrementBy(numOverflows, floor: floor, ceiling: ceiling)
        }
        return remString+String(newLastChar)
    }
}

extension Array {
    
    /**
    Shuffles the array using the modern Fisher-Yates algorithm.
    
    - returns: The shuffled array.
    */
    func shuffle() -> Array<Element> {
        var shuffledArray = self
        let count = shuffledArray.count
        for i in count.stride(through: 1, by: -1) {
            let j = Int(arc4random_uniform(UInt32(i)))
            let movedElement = shuffledArray.removeAtIndex(j)
            shuffledArray.insert(movedElement, atIndex: i-1)
        }
        return shuffledArray
    }
}

extension UInt {
    
    /**
    Initialises a UInt by with the value decoded from a String using a specified numberical base.
    
    - parameter string: The string to be decoded.
    - parameter radix: The numberical base to use to decode the string, e.g. 10 for decimal, 16 for hexidecimal.
    */
    init?(_ string: String, radix: UInt) {
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        var result = UInt(0)
        for digit in string.lowercaseString.characters {
            if let range = digits.rangeOfString(String(digit)) {
                let val = UInt(digits.startIndex.distanceTo(range.startIndex))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = result
    }
}