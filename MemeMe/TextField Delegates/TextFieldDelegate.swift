//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 27/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
