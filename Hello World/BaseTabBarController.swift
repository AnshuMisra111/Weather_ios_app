//
//  BaseTabBarController.swift
//  Hello World
//
//  Created by Anshuman Misra on 30/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarController : UITabBarController {
    
    
    var weeklyData: Any!
    var dailyData: Any!
    var cityPhotos: String!
    var city: String!
    var temperatureValue: String!
    var summaryValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain, target: self, action: #selector(buttonAction)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        self.navigationItem.title = city
        
        //print(self.weeklyData)
        
        /*
        let backItem = UIBarButtonItem()
        backItem.title = "Weather"
        self.navigationItem.backBarButtonItem = backItem
 */
    }
    
    @objc func buttonAction(){
        
        
        var urlString = "https://twitter.com/intent/tweet?text="+"The current temperature at "+city+" is "
        urlString += temperatureValue+". The weather conditions are "+summaryValue!+" &hashtags=CSCI571WeatherSearch";
        
        let escapedShareString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // let mainurl = URL(string: urlString)!
        
        let url = URL(string: escapedShareString)
        
        // open in safari
        UIApplication.shared.openURL(url!)
        /*
         let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
         
         guard let data = data else { return }
         }
         task.resume()
         */
    }
}
