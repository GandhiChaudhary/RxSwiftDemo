//
//  EmployeeType.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 15/12/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation

public enum EmployeeType: String {
  case TM = "TM"
  case STM = "STM"
  case TL = "TL"
  case STL = "STL"
  case PM = "PM"
  case DO = "DO"
  case All = "All"
  
  public var name: String {
    return self.rawValue
  }
  
  public func isThis(name: String) -> Bool {
    return self.name == name
  }
  
  public static func getAllTypes() -> [EmployeeType] {
    let types: [EmployeeType] = [.TM, .STM, .TL, .STL, .PM, .DO, .All]
    return types
  }
}

