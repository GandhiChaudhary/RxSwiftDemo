//
//  LoginViewController.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 25/12/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import UIKit
import LocalAuthentication
import RealmSwift
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
  
  @IBOutlet weak var userID: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
    var context = LAContext()
    var loginViewModel = LoginViewModel()
    var disposeBag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        BindUI()
        loginViewModel.isValid.subscribe(onNext: { isvalid in
          self.loginButton.isEnabled = isvalid
          self.loginButton.backgroundColor = isvalid ? .green : .lightGray
        }).disposed(by: disposeBag)
      
      loginViewModel.authenticationStatus = { status in
        switch status {
        case .success:
          self.performSegue(withIdentifier:"HomeNavigationController", sender: nil)
        case .fail:
          break
        case .unKnown:
          self.showAlert(title: AppConstant.touchIDfailTitle.localizedCapitalized, message: AppConstant.touchIDfailMsg.localizedCapitalized)
        }
      }
    }
  
  override func viewWillAppear(_ animated: Bool) {
    loginViewModel.authenticationWithTouchID()
  }
    func BindUI() {
      userID.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.userID).disposed(by: disposeBag)
      password.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.password).disposed(by: disposeBag)
      loginButton.rx.tap.bind {self.loginPressed()}.disposed(by: disposeBag)
    }
  
  func loginPressed() {
     self.performSegue(withIdentifier:"HomeNavigationController", sender: nil)
  }
}

