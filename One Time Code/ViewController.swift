//
//  ViewController.swift
//  One Time Code
//
//  Created by Peter Bassem on 12/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    @IBOutlet weak var getOTPButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        codeTextField.digitFont = .boldSystemFont(ofSize: 40)
        codeTextField.otpDelegate = self
        getOTPButton.setTitle("get_otp".localized(), for: .normal)
    }
    
    @IBAction func getOTPButtonPressed(_ sender: UIButton) {
        
    }
}

extension ViewController: OneTimeCodeTextFieldDelegate {
    
    func didCompleteOTPText(otpText text: String) {
        print(text)
    }
    
    func isValidCode(isValid valid: Bool) {
        print("should enable next button?", valid)
    }
}

extension String {
    
    func localized() -> String {
        let path = Bundle.main.path(forResource: LocalizationHelper.getCurrentLanguage(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
