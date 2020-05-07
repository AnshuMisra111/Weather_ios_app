//
//  ViewController.swift
//  Hello World
//
//  Created by Anshuman Misra on 18/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UIGestureRecognizerDelegate,UITableViewDataSource {
    
   // var parentViewController : ScrollableViewController!
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var mainView: UIView!
    @IBOutlet var humdityValue: UILabel!
    @IBOutlet var windSpeedValue: UILabel!
    @IBOutlet var visibilityValue: UILabel!
    @IBOutlet var pressureValue: UILabel!
    @IBOutlet var summaryImage: UIImageView!
    @IBOutlet var temperatureValue: UILabel!
    @IBOutlet var summaryValue: UILabel!
    //@IBOutlet var predictiontableView: UITableView!
    var city: String!
    var didFindLocation: Bool!
    var weeklyData: Any!
    var dailyData: Any!
    
    @IBOutlet var weeklyTable: UITableView!
    @IBOutlet var firstSubView: RoundUIView!
    //@IBOutlet weak var searchBar: UISearchBar!
    var localLocation: CLLocation?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var predictions = [[String]]()
    

    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .automotiveNavigation
        _locationManager.distanceFilter = 10.0  // Movement threshold for new events
        //_locationManager.allowsBackgroundLocationUpdates = true // allow in background
        
        return _locationManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didFindLocation = false
        //print("city is ="+city)
       // setUpSearchBar();
       // predictiontableView.delegate = self
       // predictiontableView.dataSource = self
       // predictiontableView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.delegate = self
        firstSubView.addGestureRecognizer(tap)
        self.weeklyTable.layer.cornerRadius = 10
        //predictiontableView.reloadData()
        
        //searchBarContainer.addSubview(searchController.searchBar)
        //navigationItem.searchController = searchController
        //searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "detailedRequestFromViewController", sender: self)
    }
    
    

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
        vc.cityPhotos = "los%20Angeles%20CA%20USA"
        vc.city = city
        vc.temperatureValue = temperatureValue.text
        vc.summaryValue = summaryValue.text
        
        self.parent?.title = "Weather"
        
       // print("process starting..")
       // print(weeklyData)
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.requestAlwaysAuthorization()
        
        print("did load")
        print(locationManager)
        
        locationManager.startUpdatingLocation()
    }
    
    /*
    func setUpSearchBar() {
        searchBar.delegate = self;
    }
 */
    
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
                    [self.humdityValue .sizeToFit()]
                        }
                    }
                        if let windSpeed = dict["windSpeed"]as? Double{
                            var value = String(round(windSpeed*100)/100)+"mph"
                            DispatchQueue.main.async(){
                    print("windSpeed is = \(windSpeed)")
                    self.windSpeedValue.text = "\(value)"
                    [self.windSpeedValue .sizeToFit()]
                        }
                    }
                        if let visibility = dict["visibility"]as? Double{
                            var value = String(round(visibility*100)/100)+"km"
                            DispatchQueue.main.async(){
                    self.visibilityValue.text = "\(value)"
                     [self.visibilityValue .sizeToFit()]
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.predictions.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        print("In Table View = ")
        print(self.predictions)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath)
        cell.textLabel?.text = self.predictions[indexPath.row]
        return cell
         */
        
        //print("came in table view")
        var entry = self.predictions[indexPath.row]
        //print(entry)
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyCell", for: indexPath)as! WeeklyCell
        cell.imag1.image = UIImage(named:entry[1])
        cell.label1.text = entry[0]
        cell.label2.text = entry[2]
        cell.label3.text = entry[3]
        cell.image2.image = UIImage(named:"weather-sunset-up")
        cell.image3.image = UIImage(named:"weather-sunset-down")
        
        return cell
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText : String){
        
        let urlString = "https://newproject-1573689447678.appspot.com/Autocomplete?keyword="+searchText
        
        let mainurl = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
      
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                //print(json)
                if let dict2 = json as? [String : Any]{
                   self.predictions = [String]()
                    if let dict = dict2["predictions"]as? [[String: Any]]{
                        for element in dict {
                            if let place = element["description"]as? String{
                                self.predictions.append(place)
                            }
                        }
                    }
                    //print(self.predictions)
                    self.predictiontableView.reloadData()
                  //print(dict["predictions"])
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
        //print(searchText)
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //print("came here")
     
        for location in locations {
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
          /*
            print("**********************")
            print("Long \(location.coordinate.longitude)")
            print("Lati \(location.coordinate.latitude)")
            print("Alt \(location.altitude)")
            print("Sped \(location.speed)")
            print("Accu \(location.horizontalAccuracy)")
            
            print("**********************")
          */
            
        }
 
        if(!didFindLocation){
        searchWeatherInfo();
        weeklyWeatherInfo();
        //SVProgressHUD.dismiss()
        }
        didFindLocation = true
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
                        SVProgressHUD.dismiss()
                    }
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     
    }
    
}


@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}

