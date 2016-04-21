//
//  FileManager.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/29/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

class FileManager {
    
    func writeData(data: NSData, filename: String, format: String) -> Bool {
        
        if let documentsPath = getDocumentsPath() {
            
            guard let image = UIImage(data: data) else {
//                print("failed to create image from data")
                return false
            }
            
            let destinationPath = documentsPath.stringByAppendingPathComponent("\(filename).\(format)")
            
            UIImagePNGRepresentation(image)!.writeToFile(destinationPath, atomically: false)
            
//            print("\(filename) written to path")
            return true
        }
        else {
            return false
        }
    }
    
    func readData(filename: String, format: String) -> UIImage? {
        let filemgr = NSFileManager.defaultManager()
        
        if let documentsPath = getDocumentsPath() {
            
            let destinationPath = documentsPath.stringByAppendingPathComponent("\(filename).\(format)")
            
            guard let imageData = filemgr.contentsAtPath(destinationPath) else {
//                print("file \(filename) not found at path \(destinationPath)")
                return nil
            }
            
//            print("\(filename) read from path")
            return UIImage(data:imageData)
        }
        else {
            return nil}
    }
    
    func getDocumentsPath() -> NSString? {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
    }
}