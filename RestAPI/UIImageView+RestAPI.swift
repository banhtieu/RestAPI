//
//  UIImageView+RestAPI.swift
//  RestAPI
//
//  Created by Tran Thien Khiem on 1/28/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit


// request uiview
extension UIImageView {
    
    ///
    /// Set Image at a given URL
    ///
    /// :param: - url The target URL
    ///
    func setImageAtURL(url: String) {
        setImageAtURL(url, placeHolder: nil)
    }
    
    ///
    /// Set Image at a given URL with the place holder
    ///
    /// :param: url - The target URL
    /// :param: placeHolder - the default image when the target image is loading
    ///
    func setImageAtURL(url: String, placeHolder: UIImage?) {
        
        var restAPI:RestAPI = Factory.get()
        image = placeHolder
        
        // request to URL
        restAPI.request("GET", url: url, pathParams: nil, postBody: nil) {
            data in
            // create an image
            var image = UIImage(data: data)
            
            // set the image
            if let theImage = image {
                self.image = image;
            }
        }
    }
}