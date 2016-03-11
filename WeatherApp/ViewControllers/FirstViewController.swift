//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit
import Alamofire

let apiKey = "60a92dca6de741c9a0e131319161003"
let requestURL = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=44db6a862fba0b067b1930da0d769e98"

class FirstViewController: UIViewController {
    

    @IBAction func request(sender: AnyObject) {
        self.downloadData("http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=b1b15e88fa797225412429c1c50c122a")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension FirstViewController {
    func downloadData(url: String) {
        Alamofire.request(.GET,url).responseJSON { response -> Void in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Invalid tag information received from service")
                return
            }
            print(responseJSON)
        }
    }
}