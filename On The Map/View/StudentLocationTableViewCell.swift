//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
