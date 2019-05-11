//
//  CellInfo.swift
//  COMP327.Assignment.1.u6tcl.Lau.TszChung
//
//  Created by lau tszchung on 5/11/2018.
//  Copyright © 2018 lau tszchung. All rights reserved.
//

//Custom Cell Info

import UIKit

class CellInfo : UITableViewCell{
    
    //Field
    var link: TableViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .darkGray
        //Create a star button
        let star = UIButton(type: .system)
        if let image = UIImage(named: "fav_star.png") {
            star.setImage(image, for: .normal)
        }
        
        star.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        star.tintColor = .lightGray
        //Action will the star button is clicked
        star.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        accessoryView = star
    }
    
    @objc private func handleMarkAsFavorite() {
        //fucntion Set Cell in ReportTableViewController, perform favourite or un-favourite reports
        link?.SetCell(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
