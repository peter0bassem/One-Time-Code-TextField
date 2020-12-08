//
//  ViewController.swift
//  One Time Code
//
//  Created by Peter Bassem on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /// Must be before configure.
        codeTextField.defaultCharacter = "@"
        codeTextField.configure(with: 4)
        codeTextField.didEnterLastDigit = { code in
            print(code)
        }
    }
    @IBAction func getOTPButtonPressed(_ sender: UIButton) {
        
    }
}

