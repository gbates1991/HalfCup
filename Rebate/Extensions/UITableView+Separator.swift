//
//  UITableView+Separator.swift
//  Rebate
//
//  Created by Zhang Yi on 7/12/2015.
//
//

import Foundation
import UIKit

extension UITableView{
    ///Eliminates separator lines
    func eliminateSeparatorLines(){
        tableFooterView = UITableView(frame: CGRectZero)
    }
}