//
//  Employee.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 29/11/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation


open class Employee {
  
  var empID: Int?
  var empName: String?
  var contactNumber: String?
  var address: Address?
  var empType: EmployeeType?
  var userImage: String?
  
  
  init(rlmEmp: RlmEmployee) {
    self.empID = rlmEmp.id
    self.empName = rlmEmp.empName
    self.contactNumber = rlmEmp.contactNumber
    self.userImage = rlmEmp.userImage
    self.empType = EmployeeType(rawValue: rlmEmp.empType)
    self.address = Address(address1: rlmEmp.address, city: rlmEmp.city, State: rlmEmp.state)
  }
  
  init(id: Int, name: String, mobileNumber: String, localAddress: String, state: String, city: String, type: EmployeeType) {
    self.empID = id
    self.empName = name
    self.contactNumber = mobileNumber
    self.empType = type
    self.address = Address(address1: localAddress, city: city, State: state)
  }
}
