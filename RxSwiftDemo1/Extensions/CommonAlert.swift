//
//  CommonAlert.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 21/02/19.
//  Copyright © 2019 Chetu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  func showAlert(title: String, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
}
