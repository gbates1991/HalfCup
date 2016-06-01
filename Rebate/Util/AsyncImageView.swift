//
//  AsyncImageView.swift
//  Rebate
//
//  Created by Pae on 5/12/16.
//  Copyright © 2016 mstar. All rights reserved.
//

import UIKit
import ImageLoader

public class AsyncImageView: UIImageView {
    
    public var placeholderImage : UIImage?
//    var hud : PActivityHUD?
    
    public var url : URLLiteralConvertible? {
        willSet {
//            hud = activityHUD()
        }
        
        didSet {
            if let urlString = url {
                self.load(urlString, placeholder: placeholderImage, completionHandler: { (url, resultImage, error, cachType) in
//                    self.hud?.hideHUD(false)
                })
            }
        }
    }
    
    public func setURL(url: URLLiteralConvertible?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        self.url = url
    }
    
}