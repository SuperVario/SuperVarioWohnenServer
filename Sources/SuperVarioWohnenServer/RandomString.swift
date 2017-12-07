//
//  RandomString.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 01.12.17.
//

import Foundation

extension String {
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            #if os(OSX)
                let rand = arc4random_uniform(len)
            #else
                let rand = random(len)
            #endif
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
