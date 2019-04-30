//
//  RealmDatabse.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 30/11/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDatabase: Object {
  
  let Employee = List<RlmEmployee>()
  
}

class RlmEmployee: Object {
  
  @objc dynamic var id: Int = 0
  @objc dynamic var empName: String = ""
  @objc dynamic var contactNumber: String = ""
  @objc dynamic var address: String = ""
  @objc dynamic var city: String = ""
  @objc dynamic var state: String = ""
  @objc dynamic var empType: String = ""
  @objc dynamic var userImage: String = ""
}

