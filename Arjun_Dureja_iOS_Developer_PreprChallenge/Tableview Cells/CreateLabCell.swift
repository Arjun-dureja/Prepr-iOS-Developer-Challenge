//
//  CreateLabCell.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-09.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

protocol CreateLabCellDelgate {
    func didTapLocation(name: String?)
}

class CreateLabCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameField: AuthTextField!
    @IBOutlet weak var locationField: AuthTextField!
    var delegate: CreateLabCellDelgate?
    
    @IBAction func locationTapped(_ sender: Any) {
        delegate?.didTapLocation(name: nameField.text)
    }
}
