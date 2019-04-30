//
//  UnwrapString.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 19/02/19.
//  Copyright © 2019 Chetu. All rights reserved.
//

import Foundation


extension Optional {
  
  var unwrappedString: String {
    
    guard let unwrappedSelf = self as? String else {
      return ""
    }
    
    return unwrappedSelf
  }
  
  var unwrappedInt: Int {
    
    guard let unwrappedSelfInt = self as? Int else {
      return 0
    }
    
    return unwrappedSelfInt
    
  }
  
  var unwrappedDouble: Double {
    
    guard let unwrappedSelfDouble = self as? Double else {
      return 0.0
    }
    
    return unwrappedSelfDouble
    
    
  }
  
}

