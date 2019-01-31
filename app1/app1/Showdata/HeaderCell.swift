//
//  HeaderCell.swift
//  app1
//
//  Created by Promptnow on 14/1/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit

protocol DidTapHeader {
    func delegateDidTapHeader(index: Int)
}

class HeaderCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    var delegate: DidTapHeader?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.delegateDidTapHeader(index: index)
    }
    

}
