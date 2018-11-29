//
//  CacheHelper.swift
//  Sankets-TestApp
//
//  Created by Sanket on 29/11/18.
//  Copyright © 2018 Developer Sanket. All rights reserved.
//

import Foundation

class ResponseCacheHelper{

    var cache : NSCache<NSString, AnyObject>

    public static var instance:ResponseCacheHelper = {
        let cacheHelper = ResponseCacheHelper()
        return cacheHelper
    }()

    public static func get() -> ResponseCacheHelper{
        return instance
    }

    private init(){
        cache = NSCache<NSString, AnyObject>()
    }

    func writeInCache(searchKey:String,result:Data){
        if cache.object(forKey: searchKey as NSString) == nil{
            cache.setObject(result as AnyObject, forKey: searchKey as NSString)
        }
    }

    func readCache(searchKey:NSString) -> Data?{
        var data:Data?
        if cache.object(forKey: searchKey as NSString) != nil{
            data = cache.object(forKey: searchKey as NSString) as? Data
        }
        return data
    }

}

