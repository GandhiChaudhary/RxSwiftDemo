//
//  LoginViewModel.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 25/12/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication


enum TouchIdStatus {
  case fail
  case success
  case unKnown
}

struct LoginViewModel {
  
  var authenticationStatus: ((_ status: TouchIdStatus)->())?
  var userID = Variable<String>("")
  var password = Variable<String>("")
  
  var isValid: Observable<Bool> {
    return Observable.combineLatest(userID.asObservable(), password.asObservable()) { id, pass  in
      id.count >= 6 && pass.count >= 6
    }
  }
  
   func authenticationWithTouchID() {

      let localAuthenticationContext = LAContext()
      localAuthenticationContext.localizedFallbackTitle = AppConstant.fallBackTitle
      var authError: NSError?
      let reasonString = AppConstant.authReasonString
      if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
          if success {
            //TODO: User authenticated successfully, take appropriate action
            self.authenticationStatus?(TouchIdStatus.success)
          } else {
            //TODO: User cancelled the biometric authentication. So requesting to login with app credentials
            self.authenticationStatus?(TouchIdStatus.fail)
          }
        }
      }
    }
}
