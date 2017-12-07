//
//  RandomString.swift
//  SuperVarioWohnenServerPackageDescription
//
//  Created by Tobias on 01.12.17.
//

import Foundation

extension String {
    static func randomString(length: Int) -> String {
        
        let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)
        let len = UInt32(letters.count)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            #if os(OSX)
                let rand = arc4random_uniform(len)
            #else
                let rand = UInt32(random()) % len
            #endif
            let nextChar = letters[Int(rand)]
            randomString.append(nextChar)
        }
        
        return randomString
    }
}
