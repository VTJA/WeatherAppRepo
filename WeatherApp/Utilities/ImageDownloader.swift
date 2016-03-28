//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/28/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

class ImageDownloader : NSOperation {
    let imageURL : NSURL
    var imageData: NSData?
    
    init(url: NSURL) {
        imageURL = url
    }
    
    override func main() {
        
        if self.cancelled { return }
        
        let imageData = NSData(contentsOfURL:imageURL)
        
        if imageData?.length > 0 {
            print("image \(imageURL) downloaded ")
            self.imageData = imageData
        } else {
            print("failed to download image \(imageURL)")
        }
    }
}




