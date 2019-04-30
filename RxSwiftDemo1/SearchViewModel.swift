//
//  SearchViewModel.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 11/09/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

final class SearchViewModel {
  
     var emplyees = Variable<[Employee]>([])
     var filteredEmplyees = Variable<[Employee]>([])
     var employeeTypes = EmployeeType.getAllTypes()
     var selectedEmpType = Variable<String>("")
      
     func getAllEmployees() {
        do {
          let realm = try Realm()
          let allEntries = realm.objects(RlmEmployee.self)
          emplyees.value.removeAll()
          emplyees.value = allEntries.map { rlmEmp in
          return Employee(rlmEmp: rlmEmp)
          }
        } catch { debugPrint("Unable to open realm") }
    }
  
  func getAllRealmEmployees() -> Results<RlmEmployee>? {
    do {
      let realm = try Realm()
      let allEntries = realm.objects(RlmEmployee.self)
      return allEntries
    } catch { debugPrint("Unable to open realm") }
    return nil
  }
      
    func deleteEmployeeFromRealm(emp: RlmEmployee) {
        do {
          let realm = try Realm()
          try realm.write { realm.delete(emp) }
        } catch { debugPrint("Unable to open realm") }
    }
      
    func numberOfrowsInComponent() -> Int {
        return employeeTypes.count
    }
      
    func titleForRow(row: Int) -> String {
        return employeeTypes[row].rawValue
    }
      
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
      
    func writeUserImage(empID: String, image: UIImage) -> String {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(empID).jpg")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
          if let data = UIImageJPEGRepresentation(image, 1.0) {
            do {
              try data.write(to: fileURL)
              debugPrint("file saved")
              return fileURL.path
            } catch { debugPrint("Some error occur"); return "" }
          }
        }
      return ""
    }
}
