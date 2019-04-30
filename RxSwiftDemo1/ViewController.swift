//
//  ViewController.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 11/09/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var empTypeSelectionButton: UIButton!
  
    var searchViewModel = SearchViewModel()
    var selectedEmpType = Variable<EmployeeType>(EmployeeType.All)
    fileprivate var disposeBag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        searchBar.autocapitalizationType = .none
        empTypeSelectionButton.addTarget(self, action:#selector(ViewController.showEmployeeTypes), for: .touchUpInside)
        searchViewModel.getAllEmployees()
        BindUI()
      
    }
  override func viewWillAppear(_ animated: Bool) {
    searchViewModel.getAllEmployees()
    self.itemTableView.reloadData()
  }
    
    func BindUI() {
      
     Observable.combineLatest(searchViewModel.emplyees.asObservable(),selectedEmpType.asObservable(), searchBar.rx.text,resultSelector:{ employees,selectedEmpType,search in
      
           return  employees.filter { emply -> Bool in
                return self.shouldDisplayEmployee(emp: emply, empType: selectedEmpType, searchText: search!)
            }
        })
        .bind(to: searchViewModel.filteredEmplyees)
        .disposed(by: disposeBag)

        searchViewModel.filteredEmplyees.asObservable()
            .subscribe(onNext: { [weak self]value in
                self?.itemTableView.reloadData()
            }).disposed(by: disposeBag)
    }
  
  func shouldDisplayEmployee(emp: Employee, empType: EmployeeType, searchText: String) -> Bool {
    
    guard let name = emp.empName else { return false}
    if empType == EmployeeType.All && searchText.isEmpty {
      return true
    } else if empType != EmployeeType.All && searchText.isEmpty {
      return emp.empType == empType ? true : false
    } else {
      switch empType {
      case .All:
        return name.lowercased().contains(searchText.lowercased()) ? true : false
      default:
        return name.lowercased().contains(searchText.lowercased()) && emp.empType == empType ? true : false
      }
     
    }
  }
  
  @objc func showEmployeeTypes() {
    
    let alert = UIAlertController(title: AppConstant.empTypes, message: AppConstant.empTypesMsg , preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: EmployeeType.TM.rawValue, style: .default , handler:{ (UIAlertAction)in
      self.empTypeSelectionButton.setTitle(EmployeeType.TM.rawValue, for: .normal)
      self.selectedEmpType.value = EmployeeType.TM
    }))
    
    alert.addAction(UIAlertAction(title: EmployeeType.STM.rawValue, style: .default , handler:{ (UIAlertAction)in
      self.empTypeSelectionButton.setTitle(EmployeeType.STM.rawValue, for: .normal)
      self.selectedEmpType.value = EmployeeType.STM
    }))
    
    alert.addAction(UIAlertAction(title: EmployeeType.TL.rawValue, style: .default , handler:{ (UIAlertAction)in
      self.empTypeSelectionButton.setTitle(EmployeeType.TL.rawValue, for: .normal)
      self.selectedEmpType.value = EmployeeType.TL
    }))
    
    alert.addAction(UIAlertAction(title:EmployeeType.STL.rawValue, style: .default, handler:{ (UIAlertAction)in
      self.empTypeSelectionButton.setTitle(EmployeeType.STL.rawValue, for: .normal)
       self.selectedEmpType.value = EmployeeType.STL
    }))
    
    alert.addAction(UIAlertAction(title:EmployeeType.All.rawValue, style: .default, handler:{ (UIAlertAction)in
      self.empTypeSelectionButton.setTitle(EmployeeType.All.rawValue, for: .normal)
       self.selectedEmpType.value = EmployeeType.All
    }))
    
    alert.addAction(UIAlertAction(title:"Cancel".localizedCapitalized, style: .cancel, handler: nil))
    
    self.present(alert, animated: true, completion: nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      
      let employee = searchViewModel.filteredEmplyees.value[indexPath.row]
      guard let rlmEmployees = searchViewModel.getAllRealmEmployees() else { return }
      for emp in rlmEmployees {
        if emp.id == employee.empID {
          self.searchViewModel.deleteEmployeeFromRealm(emp: emp)
          self.searchViewModel.emplyees.value.remove(at: indexPath.row)
          self.itemTableView.reloadData()
          break
        }
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.filteredEmplyees.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as? EmployeeCell else { return UITableViewCell() }
      cell.employeeID.text = String(searchViewModel.filteredEmplyees.value[indexPath.row].empID.unsafelyUnwrapped)
      cell.userName.text = searchViewModel.filteredEmplyees.value[indexPath.row].empName
      cell.userContactNo.text = searchViewModel.filteredEmplyees.value[indexPath.row].contactNumber
      if let address = searchViewModel.filteredEmplyees.value[indexPath.row].address {
           cell.userAddress.text = address.address1.unwrappedString + " " + address.city.unwrappedString + ", " + address.state.unwrappedString
      }
      if let userIcon = searchViewModel.filteredEmplyees.value[indexPath.row].userImage {
        
        if let image = UIImage(contentsOfFile: userIcon) {
          cell.userImageIcon.image = image
        } else {
          cell.userImageIcon.image =  UIImage(named: "user_icon")
        }
        
      } else {
         cell.userImageIcon.image = UIImage(named: "user_icon")
      }
      cell.userImageIcon.layer.masksToBounds = true
      cell.userImageIcon.layer.cornerRadius = cell.userImageIcon.frame.size.width / 2
      cell.userImageIcon.contentMode = .scaleAspectFill
      cell.baseView.layer.cornerRadius = 7
      cell.backgroundColor = .clear
      return cell
    }
}


