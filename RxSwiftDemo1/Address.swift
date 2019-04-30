//
//  Address.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 29/11/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation

open class Address {
  
  var address1: String?
  var city: String?
  var state: String?
  
  init(address1: String, city: String, State: String) {
    self.address1 = address1
    self.city = city
    self.state = State
  }
}
