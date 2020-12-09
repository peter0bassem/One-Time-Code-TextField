//
//  LocalizationHelper.swift
//  SelfService
//
//  Created by Imac on 7/9/20.
//  Copyright © 2020 IbnSinai. All rights reserved.
//

import UIKit

class LocalizationHelper {
    // MARK: - variables

    class func isArabic() -> Bool {
        return getCurrentLanguage() == LanguageConstants.arabicLanguage.rawValue
    }
}

// MARK: - set Views Semantics

extension LocalizationHelper {
    fileprivate class func setViewsSemantics() {
        if (LocalizationHelper.getCurrentLanguage() == LanguageConstants.arabicLanguage.rawValue){
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UISegmentedControl.appearance().semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UITableView.appearance().semanticContentAttribute = .forceRightToLeft
//            UISegmentedControl.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UISegmentedControl.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UITableView.appearance().semanticContentAttribute = .forceLeftToRight
//            UISegmentedControl.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

// MARK: - reset

extension LocalizationHelper {
//    class func reset() {
//        if #available(iOS 13.0, *) {
//             let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//            sceneDelegate?.setRoot()
//        } else {
//            appDelegate?.setRoot()
//        }
//    }
    
    class func isSameAsPrefered() -> Bool{
        return Locale.current.languageCode == LocalizationHelper.getCurrentLanguage()
    }
}

// MARK: - set Current Lang

extension LocalizationHelper {
    class func setCurrentLang(lang: String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(lang, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize() //needs restrat
        LocalizationHelper.setViewsSemantics()
    }
}

// MARK: - get Current Language

extension LocalizationHelper {
    class func getCurrentLanguage() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: LanguageConstants.appleLanguage.rawValue) as? NSArray
        let current = langArray?.firstObject as? String
        if let current = current {
            let currentWithoutLocale = String(current[..<current.index(current.startIndex, offsetBy: 2)])
            return currentWithoutLocale
        }
        return LanguageConstants.englishLanguage.rawValue
    }
}

enum LanguageConstants: String {
    case appleLanguage = "AppleLanguages"
    case englishLanguage = "en"
    case arabicLanguage = "ar"
}
