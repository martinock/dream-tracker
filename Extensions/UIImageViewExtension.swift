//
//  UIImageViewExtension.swift
//  DreamTracker
//
//  Created by nakama on 09/12/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import Alamofire
import UIKit

extension UIImageView {
    func loadImageFrom(url: URL?) {
        if let imageUrl = url {
            Alamofire.request(imageUrl).responseData{(response) in
                guard let data = response.data,
                    let image = UIImage(data: data) else {
                        return
                }
                
                self.image = image
            }
        }
    }
}
