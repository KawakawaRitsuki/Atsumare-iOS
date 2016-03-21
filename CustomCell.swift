//
//  CustomCell.swift
//  atsumare
//
//  Created by 五嶋 律樹 on 2016/01/22.
//  Copyright © 2016年 KawakawaPlanning. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mId: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(login :LoginModel) {
        self.mId.text = login.id as String
        self.mName.text = login.name as String
        self.mImage!.image = login.image
    }
}
