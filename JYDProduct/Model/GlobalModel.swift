//
//  GlobalModel.swift
//  FXDProduct
//
//  Created by admin on 2017/8/2.
//  Copyright © 2017年 admin. All rights reserved.
//

import Foundation
import HandyJSON


struct BaseModel<T>:HandyJSON{
    
    var flag : String?
    var msg : String?
    var result : T?
    
}










