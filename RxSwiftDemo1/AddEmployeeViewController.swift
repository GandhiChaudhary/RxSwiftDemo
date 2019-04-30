//
//  AddEmployeeViewController.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 06/12/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Foundation

class AddEmployeeViewController: UIViewController {
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var employeeID: UILabel!
  @IBOutlet weak var employeeName: UITextField!
  @IBOutlet weak var mobileNumber: UITextField!
  @IBOutlet weak var localAddress: UITextField!
  @IBOutlet weak var state: UITextField!
  @IBOutlet weak var city: UITextField!
  @IBOutlet weak var editProfileImageButton: UIButton!
  @IBOutlet weak var addEmployeeButton: UIButton!
  @IBOutlet weak var selectEmployeeType: UIButton!
  
  
  let searchViewModel = SearchViewModel()
  let imagePickerController = UIImagePickerController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      userImage.layer.masksToBounds = true
      userImage.layer.cornerRadius = userImage.frame.size.width / 2
      imagePickerController.delegate = self
      employeeName.delegate = self
      mobileNumber.delegate = self
      localAddress.delegate = self
      city.delegate = self
      state.delegate = self
      let newEmpid = getMaxEmpIdFromRealm()
      if let id = newEmpid {
         self.employeeID.text = String(id + 1)
      }
     
      addEmployeeButton.addTarget(self, action:#selector(AddEmployeeViewController.addEmployee(_:)), for: .touchUpInside)
       selectEmployeeType.addTarget(self, action:#selector(AddEmployeeViewController.showEmployeeTypes), for: .touchUpInside)
      editProfileImageButton.addTarget(self, action:#selector(AddEmployeeViewController.updateProfileImage), for: .touchUpInside)
    }
    func getMaxEmpIdFromRealm() -> Int? {
      do {
        let realm = try Realm()
        let allEntries = realm.objects(RlmEmployee.self)
        if allEntries.count > 0 {
          let id = allEntries.max(ofProperty: "id") ?? 0 as Int
            return id
          } else { return 1000 }
        } catch { debugPrint("Unable to open realm") }
     return nil
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @objc func updateProfileImage() {
    imagePickerController.allowsEditing = false
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func fieldValidation() -> Bool {
    return employeeID.text != "" &&
            employeeName.text != "" &&
            mobileNumber.text != "" &&
            localAddress.text != "" &&
            state.text != "" &&
            state.text != "" &&
            selectEmployeeType.titleLabel?.text != AppConstant.empTypesMsg
  }
  
  @objc func addEmployee(_ sender: UIButton!) {
    
    if let empid = employeeID.text,
       let name = employeeName.text,
       let contactNo = mobileNumber.text,
       let address = localAddress.text,
       let city = city.text,
    let state = self.state.text,
      let emptype = selectEmployeeType.titleLabel?.text {
       if fieldValidation() {
      
       let rlmEmployee = RlmEmployee()
        rlmEmployee.id = Int(empid) ?? 0
           rlmEmployee.empName = name
           rlmEmployee.contactNumber = contactNo
           rlmEmployee.address = address
           rlmEmployee.city = city
           rlmEmployee.state = state
           rlmEmployee.empType = emptype
        if let img = self.userImage.image {
          rlmEmployee.userImage =  searchViewModel.writeUserImage(empID: empid, image:img)
        }
        
        do {
          let realm = try Realm ()
          try realm.write {
            realm.add(rlmEmployee)
          }
        } catch { debugPrint("Unable to open realm") }
       } else {
        let alertController =  UIAlertController(title: "Error".localizedCapitalized, message: "Please fill mendatory fields".localizedCapitalized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok".localizedCapitalized, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
      }
    }
    
  }
  
  @objc func showEmployeeTypes() {
    
    let alert = UIAlertController(title: AppConstant.empTypes, message: AppConstant.empTypesMsg, preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: EmployeeType.TM.rawValue, style: .default , handler:{ (UIAlertAction)in
      self.selectEmployeeType.setTitle(EmployeeType.TM.rawValue, for: .normal)
    }))
    
    alert.addAction(UIAlertAction(title: EmployeeType.STM.rawValue, style: .default , handler:{ (UIAlertAction)in
       self.selectEmployeeType.setTitle(EmployeeType.STM.rawValue, for: .normal)
    }))
    
    alert.addAction(UIAlertAction(title: EmployeeType.TL.rawValue, style: .default , handler:{ (UIAlertAction)in
       self.selectEmployeeType.setTitle(EmployeeType.TL.rawValue, for: .normal)
    }))
    
    alert.addAction(UIAlertAction(title:EmployeeType.STL.rawValue, style: .default, handler:{ (UIAlertAction)in
       self.selectEmployeeType.setTitle(EmployeeType.STL.rawValue, for: .normal)
    }))
    
    alert.addAction(UIAlertAction(title:"Cancel".localizedCapitalized, style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

}

extension AddEmployeeViewController: UITextFieldDelegate {
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    return true
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder();
    return true
  }
}

extension AddEmployeeViewController: UIImagePickerControllerDelegate {
  
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      userImage.contentMode = .scaleAspectFill
      userImage.image = pickedImage
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion:nil)
  }
}

extension AddEmployeeViewController: UINavigationControllerDelegate {
  
}

