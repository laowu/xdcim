//
//  XDCRegex.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/9.
//  Copyright © 2017年 bdw. All rights reserved.
//


import Foundation


class XDCRegex{
    
    var regex: NSRegularExpression?
    init(pattern: String) {
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        }catch{
            XDCLog("NSRegularExpression init ERR")
        }
        
    }
    func match(input: String) -> Bool {
        if let matchesResult = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)){
            return matchesResult.count > 0
        }else{
            return false
        }
    }
}
