//
//  SearchResultController.swift
//  Hello World
//
//  Created by Anshuman Misra on 30/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class SearchResultController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var firstSubView: UIView!
    var flag: Int!
    var flag2: Int!
    var city: String!
    var photoUrl: String!
    var address: String!
    var parentView: ScrollableViewController!
    
    @IBOutlet var summaryIcon: UIImageView!
    @IBOutlet var summaryValue: UILabel!
    
    var weeklyData: Any!
    var dailyData: Any!
    var predictions = [[String]]()
    
    @IBOutlet var temperatureValue: UILabel!
    
    @IBOutlet var humdityValue: UILabel!
    @IBOutlet var windSpeedValue: UILabel!
    
    @IBOutlet var visibilityValue: UILabel!
    
    @IBOutlet var pressureValue: UILabel!
    @IBOutlet var weeklyTable: UITableView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var cancelOrAdd: UIButton!
    //@IBOutlet var cancelOrAdd: UIImageView!
    
    var userDefault = UserDefaults.standard
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
   // var overlay : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading..")
       // overlay = UIView(frame: view.frame)
       // overlay.center = view.center
        //overlay.alpha = 0
        //overlay.backgroundColor = UIColor.black
        //view.addSubview(overlay)
        //view.bringSubview(toFront: overlay)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.delegate = self
        firstSubView.addGestureRecognizer(tap)
        cityLabel.text = city
        self.weeklyTable.layer.cornerRadius = 10
       // self.view.isHidden = true
        
        let button1 = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain, target: self, action: #selector(buttonAction)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = button1
        
        /*
        let tapOnCancelOrAdd = UITapGestureRecognizer(target: self, action: #selector(cancelOrAddTapped(sender:)))
        tapOnCancelOrAdd.delegate = self
        cancelOrAdd.addGestureRecognizer(tapOnCancelOrAdd)
   */
        
        navigationItem.title = city
        //perform(#selector(setLatitudeAndLongitude), with: nil, afterDelay: 3)
        setLatitudeAndLongitude()
        
    }
    
    
    @objc func buttonAction(){
        
        
        var urlString = "https://twitter.com/intent/tweet?text="+"The current temperature at "+city+" is "
        urlString += temperatureValue.text!+". The weather conditions are "+summaryValue.text!+" &hashtags=CSCI571WeatherSearch";
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(flag==1){
            /*
            cancelOrAdd.image = UIImage(named:"trash-can")
 */
            cancelOrAdd.setImage(UIImage(named: "trash-can"), for: UIControlState.normal)
        }
        else{
          //  cancelOrAdd.image = UIImage(named:"plus-circle")
            
            cancelOrAdd.setImage(UIImage(named: "plus-circle"), for: UIControlState.normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.predictions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var entry = self.predictions[indexPath.row]
        print("In table view --search \(latitude) \(longitude) ")
        print(entry)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyCell", for: indexPath)as! WeeklyCell
        cell.searchImage1.image = UIImage(named:entry[1])
        cell.searchLabel1.text = entry[0]
        cell.searchLabel2.text = entry[2]
        cell.searchLabel3.text = entry[3]
        cell.searchImage2.image = UIImage(named:"weather-sunset-up")
        cell.searchImage3.image = UIImage(named:"weather-sunset-down")
        
        return cell
    }
    
    func searchWeatherInfo(){
        print("Came here = \(latitude) and  \(longitude)")
        //print("city is = \(city)")
        
        let urlString = "https://newproject-1573689447678.appspot.com/WeatherData?latitude=\(latitude)&longitude=\(longitude)";
        
        let mainurl = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
            
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                // print(json)
                if let dict2 = json as? [String : Any]{
                    self.dailyData = dict2["currently"]
                    if let dict = dict2["currently"] as? [String: Any]{
                        
                        if let humidity = dict["humidity"] as? Double {
                            var value =  String(Int64(humidity*100.0))+"%"
                            print("humidity is = \(value)")
                            DispatchQueue.main.async(){
                                self.humdityValue.text = "\(value)"
                            }
                        }
                        if let windSpeed = dict["windSpeed"]as? Double{
                            var value = String(round(windSpeed*100)/100)+"mph"
                            DispatchQueue.main.async(){
                                print("windSpeed is = \(windSpeed)")
                                self.windSpeedValue.text = "\(value)"
                            }
                        }
                        if let visibility = dict["visibility"]as? Double{
                            var value = String(round(visibility*100)/100)+"km"
                            DispatchQueue.main.async(){
                                self.visibilityValue.text = "\(value)"
                            }
                        }
                        if let pressure = dict["pressure"]as? Double{
                            var value = String(round(pressure*100)/100)+"mb"
                            DispatchQueue.main.async(){
                                self.pressureValue.text = "\(value)"
                            }
                        }
                        
                        if let temperature = dict["temperature"]as? Double{
                            var value = String(round(temperature*100)/100)
                            DispatchQueue.main.async(){
                                self.temperatureValue.text = "\(value)"
                            }
                        }
                        if let summary = dict["summary"]as? String{
                            var value = String(summary)
                            DispatchQueue.main.async(){
                                print("summary is = \(summary)")
                                self.summaryValue.text = "\(value)"
                                [self.summaryValue .sizeToFit()]
                            }
                        }
                        if let icon = dict["icon"]as? String{
                            if(icon.elementsEqual("clear-day")){
                                DispatchQueue.main.async(){
                                    self.summaryIcon.image = UIImage(named:"weather-sunny")
                                }
                            }  else{
                                if(icon.elementsEqual("clear-night")){
                                    DispatchQueue.main.async(){
                                        self.summaryIcon.image = UIImage(named: "weather-night")
                                    }
                                } else{
                                    if(icon.elementsEqual("rain")){
                                        DispatchQueue.main.async(){
                                            self.summaryIcon.image = UIImage(named:"weather-rainy") } } else{
                                        if(icon.elementsEqual("sleet")){
                                            DispatchQueue.main.async(){
                                                self.summaryIcon.image = UIImage(named:"weather-snowy-rainy")
                                            }
                                        }
                                        else{
                                            if(icon.elementsEqual("snow")){
                                                DispatchQueue.main.async(){
                                                    self.summaryIcon.image = UIImage(named:"weather-snowy")
                                                }
                                                
                                            }
                                            else{
                                                if(icon.elementsEqual("wind")){
                                                    DispatchQueue.main.async(){
                                                        self.summaryIcon.image = UIImage(named:"weather-windy-variant")
                                                    }
                                                    
                                                }
                                                else{
                                                    if(icon.elementsEqual("fog")){
                                                        DispatchQueue.main.async(){
                                                            self.summaryIcon.image = UIImage(named:"weather-fog")
                                                        }
                                                        //randomEntry.append("weather-fog")
                                                    }
                                                    else{
                                                        if(icon.elementsEqual("cloudy")){
                                                            DispatchQueue.main.async(){
                                                                self.summaryIcon.image = UIImage(named:"weather-cloudy")
                                                            }
                                                            // randomEntry.append("weather-cloudy")
                                                        }
                                                        else{
                                                            if(icon.elementsEqual("partly-cloudy-night")){
                                                                DispatchQueue.main.async(){
                                                                    self.summaryIcon.image = UIImage(named:"weather-night-partly-cloudy")
                                                                }
                                                                // randomEntry.append("weather-night-partly-cloudy")
                                                            }
                                                            else{
                                                                if(icon.elementsEqual("partly-cloudy-day")){
                                                                    DispatchQueue.main.async(){
                                                                        self.summaryIcon.image = UIImage(named:"weather-partly-cloudy")
                                                                    }
                                                                    // randomEntry.append("weather-partly-cloudy")
                                                                }
                                                                else{
                                                                    DispatchQueue.main.async(){
                                                                        self.summaryIcon.image = UIImage(named:"weather-sunny")
                                                                    }
                                                                } } } } } } } } }
                            }
                            }
                        
                    }
                    //print(dict2["currently"])
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    func weeklyWeatherInfo(){
        
        let urlString = "https://newproject-1573689447678.appspot.com/WeatherData?latitude=\(latitude)&longitude=\(longitude)";
        
        let mainurl = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
            
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                // print(json)
                if let dict2 = json as? [String : Any]{
                    self.weeklyData = dict2["daily"]
                    if let dict3 = dict2["daily"]as? [String: Any]{
                        //print(dict3["data"])
                        // print(dict3["summary"])
                        if let dict = dict3["data"]as? NSArray{
                            //print(dict)
                            self.predictions = [[String]]()
                            for i in 0 ..< dict.count {
                                var randomEntry = [String]()
                                if let entry = dict[i]as? [String: Any]{
                                    
                                    if let dateentry = entry["time"]as? Double {
                                        let date = Date(timeIntervalSince1970: dateentry)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
                                        dateFormatter.locale = NSLocale.current
                                        dateFormatter.dateFormat = "MM/dd/yyyy" //Specify your format that you want
                                        let strDate = dateFormatter.string(from: date)
                                        randomEntry.append(strDate)
                                        // print(strDate)
                                    }
                                    
                                    if let icon = entry["icon"]as? String {
                                        
                                        if(icon.elementsEqual("clear-day")){
                                            randomEntry.append("weather-sunny")
                                        }  else{
                                            if(icon.elementsEqual("clear-night")){
                                                randomEntry.append("weather-night") } else{
                                                if(icon.elementsEqual("rain")){
                                                    randomEntry.append("weather-rainy") } else{
                                                    if(icon.elementsEqual("sleet")){
                                                        randomEntry.append("weather-snowy-rainy")
                                                    }
                                                    else{
                                                        if(icon.elementsEqual("snow")){
                                                            randomEntry.append("weather-snowy")
                                                        }
                                                        else{
                                                            if(icon.elementsEqual("wind")){
                                                                randomEntry.append("weather-windy-variant")
                                                            }
                                                            else{
                                                                if(icon.elementsEqual("fog")){
                                                                    randomEntry.append("weather-fog")
                                                                }
                                                                else{
                                                                    if(icon.elementsEqual("cloudy")){
                                                                        randomEntry.append("weather-cloudy")
                                                                    }
                                                                    else{
                                                                        if(icon.elementsEqual("partly-cloudy-night")){
                                                                            randomEntry.append("weather-night-partly-cloudy")
                                                                        }
                                                                        else{
                                                                            if(icon.elementsEqual("partly-cloudy-day")){
                                                                                randomEntry.append("weather-partly-cloudy")
                                                                            }
                                                                            else{
                                                                                randomEntry.append("weather-sunny") } } } } } } } } }
                                        }
                                    }
                                    if let sunriseTime = entry["sunriseTime"]as? Double {
                                        //print(sunriseTime)
                                        let date = Date(timeIntervalSince1970: sunriseTime)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
                                        dateFormatter.locale = NSLocale.current
                                        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
                                        let strDate = dateFormatter.string(from: date)
                                        //print(strDate)
                                        randomEntry.append(strDate)
                                    }
                                    if let sunsetTime = entry["sunsetTime"]as? Double {
                                        //print(sunriseTime)
                                        let date = Date(timeIntervalSince1970: sunsetTime)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
                                        dateFormatter.locale = NSLocale.current
                                        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
                                        let strDate = dateFormatter.string(from: date)
                                        //print(strDate)
                                        randomEntry.append(strDate)
                                    }
                                    //self.predictions.append(randomEntry)
                                }  //entry loop finishes here
                                
                                self.predictions.append(randomEntry)
                            }
                            //print(self.predictions)
                            DispatchQueue.main.async(){
                                self.weeklyTable.reloadData()
                            }
                            
                        }
                    }
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        SVProgressHUD.dismiss()
  
        self.view.isHidden = false
        
    }
    
    
    
    @objc func setLatitudeAndLongitude() {
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address="+address+"&key=AIzaSyBy2MEexehHdEUnjPn5ViNLvv5YwKzFyBI"
        let mainurl = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                //print(json)
                if let temp = json{
                    if let subEntry = temp["results"] as? NSArray{
                          //print("subEntry")
                          //print(subEntry)
                        if let firstEntry = subEntry[0]as? [String:Any]{
                           // print("firstEntry")
                            //print(firstEntry)
                            if let geometry = firstEntry["geometry"]as? [String:Any]{
                                print("geometry")
                                if let location = geometry["location"]as? [String:Any] {
                                    print("location")
                                if let lat = location["lat"] as? Double{
                                    self.latitude = lat
                                    print("lat")
                                }
                                if let long = location["lng"]as? Double{
                                    self.longitude = long
                                    print("long")
                                }
                            }
                                self.searchWeatherInfo();
                                self.weeklyWeatherInfo();
                            }
                        }
                    }
                }
            
            }
            catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
       //searchWeatherInfo();
       //weeklyWeatherInfo();
    }
    
    
    
    @objc func viewTapped(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "searchDetailedRequest", sender: self)
    }
    
    
    @IBAction func CancelOrAddTapped(_ sender: Any) {
        
        print("tap gesture recognised")
        if(flag==1){
            flag = 0
            userDefault.removeObject(forKey: city)
            var obj = UserDefaults.standard.object(forKey: "CITY ARRAY")as! Array<String>
                if let index = obj.index(of: city){
                    obj.remove(at: index)
                }
            userDefault.set(obj,forKey: "CITY ARRAY")
            
            cancelOrAdd.setImage(UIImage(named: "plus-circle"), for: UIControlState.normal)
            var Text = city + " removed from the favourite list"
            Toast(text: Text, delay: 0, duration: 1 ).show()
            //self.view.makeToast(Text, duration: 0.5, position: "bottom")
            if(flag2==1){
                //var parentView = self.view.superview
                self.view.removeFromSuperview()
                parentView.setUpView()
            }
        }
        else{
            flag = 1
            var entry = ["city":city,"address":address,"photo-url":photoUrl]
            var obj = UserDefaults.standard.object(forKey: "CITY ARRAY")as! Array<String>
                obj.append(city)
            userDefault.set(obj,forKey: "CITY ARRAY")
            
            userDefault.set(entry,forKey: city)
            cancelOrAdd.setImage(UIImage(named: "trash-can"), for: UIControlState.normal)
            var Text = city + " added to the favourite list"
            Toast(text: Text, delay: 0, duration: 1 ).show()
            //self.view.makeToast(Text, duration: 0.5, position: "bottom")

        }
        
    }
    
    
    /*
    @objc func cancelOrAddTapped(sender: UITapGestureRecognizer){
        
        print("tap gesture recognised")
        if(flag==1){
            flag = 0;
            cancelOrAdd.image = UIImage(named:"plus-circle")
        }
        else{
            flag = 1
            cancelOrAdd.image = UIImage(named:"trash-can")
        }
    }
 */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("came for selection..")
        // let backItem = UIBarButtonItem()
        // backItem.title = "Weather"
        //self.navigationItem.backBarButtonItem = backItem
        //self.navigationItem.title = "Weather"
        //self.navigationItem.backBarButtonItem!.title = "Weather"
        var vc = segue.destination as! BaseTabBarController
        vc.weeklyData = weeklyData
        vc.dailyData = dailyData
        vc.cityPhotos = photoUrl
        vc.city = city
        vc.temperatureValue = temperatureValue.text
        vc.summaryValue = summaryValue.text
        // print("process starting..")
        // print(weeklyData)
    }
}
