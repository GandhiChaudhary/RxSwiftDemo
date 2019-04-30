//
//  EmployeeCell.swift
//  RxSwiftDemo1
//
//  Created by Chetu on 29/11/18.
//  Copyright © 2018 Chetu. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
  
  
  @IBOutlet weak var baseView: UIView!
  @IBOutlet weak var userImageIcon: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var employeeID: UILabel!
  @IBOutlet weak var userAddress: UILabel!
  @IBOutlet weak var userContactNo: UILabel!
  @IBOutlet weak var isFavoriteEmp: UIImageView!
  
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
