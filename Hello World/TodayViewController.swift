//
//  TodayViewController.swift
//  Hello World
//
//  Created by Anshuman Misra on 30/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit


class TodayViewController : UIViewController {
    
    //@IBOutlet var windSpeedValue: UILabel!
    @IBOutlet var windSpeedValue: UILabel!
    @IBOutlet var temperatureValue: UILabel!
    @IBOutlet var pressureValue: UILabel!
    @IBOutlet var ozoneValue: UILabel!
    
    @IBOutlet var precipitationValue: UILabel!
    @IBOutlet var humidityValue: UILabel!
    @IBOutlet var cloudCoverValue: UILabel!
    @IBOutlet var summaryValue: UILabel!
    @IBOutlet var visibilityValue: UILabel!
    
    var mainData: Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! BaseTabBarController
        mainData = tabBar.dailyData
        setUpValues()
    }
    
    func setUpValues() {
        if let entry = mainData as? [String:Any]{
            if let value2 = entry["humidity"]as? Double{
                var value =  String(Int64(value2*100.0))+"%"
                DispatchQueue.main.async(){
                    self.humidityValue.text = "\(value)"
                }
            }
            if let value2 = entry["temperature"]as? Double{
                var value =  round(value2*100)/100
                DispatchQueue.main.async(){
                    self.temperatureValue.text = "\(value)"
                }
            }
            if let pressure = entry["pressure"]as? Double{
                var value = String(round(pressure*100)/100)+"mb"
                DispatchQueue.main.async(){
                    self.pressureValue.text = "\(value)"
                }
            }
            
            if let visibility = entry["visibility"]as? Double{
                var value = String(round(visibility*100)/100)+"km"
                DispatchQueue.main.async(){
                    self.visibilityValue.text = "\(value)"
                }
            }
            if let windSpeed = entry["windSpeed"]as? Double{
                var value = String(round(windSpeed)*100)+"mph"
                DispatchQueue.main.async(){
                   // print("windSpeed is = \(windSpeed)")
                    self.windSpeedValue.text = "\(value)"
                }
            }
            if let summary = entry["summary"]as? String{
                var value = String(summary)
                DispatchQueue.main.async(){
                    self.summaryValue.text = "\(value)"
                    [self.summaryValue .sizeToFit()]
                }
            }
            if let ozone = entry["ozone"]as? Double{
                var value = String(round(ozone*100)/100)+"DU"
                DispatchQueue.main.async(){
                    self.ozoneValue.text = "\(value)"
                }
            }
            
            if let precipitation = entry["precipIntensity"]as? Double{
                var value = String(round(precipitation*100)/100)+"mmph"
                DispatchQueue.main.async(){
                    self.precipitationValue.text = "\(value)"
                }
            }
            if let value2 = entry["cloudCover"]as? Double{
                var value =  String(round(value2*100)/100)+"%"
                DispatchQueue.main.async(){
                    self.cloudCoverValue.text = "\(value)"
                }
            }
            
        }
    }
    
    
}
