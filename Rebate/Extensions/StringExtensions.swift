//
//  StringExtensions.swift
//  Rebate
//
//  Created by Zhang Yi on 6/12/2015.
//
//

import Foundation

// MARK: - Localization
extension String{
    /**
     Get localized string from Localizable.strings file
     - Returns: Localized String from table.
     */
    func localizedString() -> String{
        return NSLocalizedString(self, tableName:"Localizable", comment:"")
    }
}

extension String{
    /**
     Removes prefix and suffix " "
    */
    func trimmedString() -> String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}