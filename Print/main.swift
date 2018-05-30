//
//  main.swift
//  Print
//
//  Created by chenwang on 2018/5/30.
//  Copyright © 2018年 罗泰. All rights reserved.
//

import Foundation

let dic = ["key1" : "\\U6d4b\\U8bd5",
           "key2" : "haha哈",
           "key3" : ["use" : "\\U6d4b\\U8bd5",
                     "user2": "kkk额"],
           "arr" : ["\\U6d4b\\U8bd5", ["subKey" : "\\U6d4b\\U8bd5"]],
           "number" : 1.33
    ] as [String : Any]

///两种方式打印都可以
//使用自定义log函数
CWLog(dic)
