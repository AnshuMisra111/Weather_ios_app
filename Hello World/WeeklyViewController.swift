//
//  WeeklyViewController.swift
//  Hello World
//
//  Created by Anshuman Misra on 30/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit
import Charts

class WeeklyViewContoller : UIViewController {
    var mainData: Any!
    
    @IBOutlet var weeklyDataChart: LineChartView!
    @IBOutlet var summaryLabel: UILabel!
    
    @IBOutlet var summaryImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! BaseTabBarController
        mainData = tabBar.weeklyData
        setChart()
        setsubView()
    }
    
    func setsubView(){
        if let dict2 = self.mainData as? [String:Any]{
            if let dict = dict2["summary"]as? String{
                summaryLabel.text = dict
                [summaryLabel .sizeToFit()]
            }
            if let icon = dict2["icon"]as? String{
                if(icon.elementsEqual("clear-day")){
                    DispatchQueue.main.async(){
                        self.summaryImage.image = UIImage(named:"weather-sunny")
                    }
                }  else{
                    if(icon.elementsEqual("clear-night")){
                        DispatchQueue.main.async(){
                            self.summaryImage.image = UIImage(named: "weather-night")
                        }
                    } else{
                        if(icon.elementsEqual("rain")){
                            DispatchQueue.main.async(){
                                self.summaryImage.image = UIImage(named:"weather-rainy") } } else{
                            if(icon.elementsEqual("sleet")){
                                DispatchQueue.main.async(){
                                    self.summaryImage.image = UIImage(named:"weather-snowy-rainy")
                                }
                            }
                            else{
                                if(icon.elementsEqual("snow")){
                                    DispatchQueue.main.async(){
                                        self.summaryImage.image = UIImage(named:"weather-snowy")
                                    }
                                    
                                }
                                else{
                                    if(icon.elementsEqual("wind")){
                                        DispatchQueue.main.async(){
                                            self.summaryImage.image = UIImage(named:"weather-windy-variant")
                                        }
                                        
                                    }
                                    else{
                                        if(icon.elementsEqual("fog")){
                                            DispatchQueue.main.async(){
                                                self.summaryImage.image = UIImage(named:"weather-fog")
                                            }
                                            //randomEntry.append("weather-fog")
                                        }
                                        else{
                                            if(icon.elementsEqual("cloudy")){
                                                DispatchQueue.main.async(){
                                                    self.summaryImage.image = UIImage(named:"weather-cloudy")
                                                }
                                                // randomEntry.append("weather-cloudy")
                                            }
                                            else{
                                                if(icon.elementsEqual("partly-cloudy-night")){
                                                    DispatchQueue.main.async(){
                                                        self.summaryImage.image = UIImage(named:"weather-night-partly-cloudy")
                                                    }
                                                    // randomEntry.append("weather-night-partly-cloudy")
                                                }
                                                else{
                                                    if(icon.elementsEqual("partly-cloudy-day")){
                                                        DispatchQueue.main.async(){
                                                            self.summaryImage.image = UIImage(named:"weather-partly-cloudy")
                                                        }
                                                        // randomEntry.append("weather-partly-cloudy")
                                                    }
                                                    else{
                                                        DispatchQueue.main.async(){
                                                            self.summaryImage.image = UIImage(named:"weather-sunny")
                                                        }
                                                    } } } } } } } } } }
            }
        }
    }
    
    func setChart(){
        let data = LineChartData()
        var firstLineChartEntry = [ChartDataEntry]()
        var secondLineChartEntry = [ChartDataEntry]()
        if let dict2 = self.mainData as? [String:Any] {
            if let dict = dict2["data"]as? NSArray{
                for i in 0..<dict.count {
                    if let entry = dict[i] as? [String:Any]{
                        firstLineChartEntry.append(ChartDataEntry(x:Double(i),y:entry["temperatureHigh"] as! Double))
                        secondLineChartEntry.append(ChartDataEntry(x:Double(i),y:entry["temperatureLow"] as! Double))
                }
                }
            }
        }
        let dataSet1 = LineChartDataSet(values: firstLineChartEntry, label: "Maximum Temperature")
        let dataSet2 = LineChartDataSet(values: secondLineChartEntry, label: "Minimum Temperature")
        //dataSet1.color = UIColor.orange
        dataSet1.setColor(UIColor.orange)
        dataSet1.setCircleColor(UIColor.orange)
        data.addDataSet(dataSet1)
        data.addDataSet(dataSet2)
        self.weeklyDataChart.data = data
    }
    
}
