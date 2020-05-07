//
//  ScrollableViewController.swift
//  Hello World
//
//  Created by Anshuman Misra on 28/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


class ScrollableViewController : UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
   // @IBOutlet var actInd: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    //var contentWidth: CGFloat = 0.0
    
    var city: String!
    var address: String!
    var photoUrl: String!
    var wholeAddress: String!
    
    @IBOutlet var predictiontableView: UITableView!
    var predictions = [String]()
    
    //@IBOutlet var searchBar: UISearchBar!
    
    let searchcontroller = UISearchController(searchResultsController: nil)
    
    //SVProgressHUD.show(withStatus: "Loading..")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading..")
        predictiontableView.delegate = self
        predictiontableView.dataSource = self
        predictiontableView.isHidden = true
       // scrollView.addSubview(actInd)
       // actInd.startAnimating()
       // actInd.hidesWhenStopped = true
        //pageControl.numberOfPages = 2
        
        /*
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        */
        self.automaticallyAdjustsScrollViewInsets = false;
        scrollView.contentInset = UIEdgeInsets.zero;
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero;
        //scrollView.contentOffset = CGPointMake(0.0, 0.0);
        
    
        if let obj = UserDefaults.standard.object(forKey: "CITY ARRAY"){
            
        }
        else{
            var cityArray = [String]()
            UserDefaults.standard.set(cityArray,forKey:"CITY ARRAY")
        }
 
        
        //scrollView.contentSize = CGSize(width: 2 * scrollView.frame.width, height: scrollView.frame.height)
        
        /*
        var contentWidth: CGFloat = 0.0
        self.scrollView.addSubview(UIView())
        contentWidth += view.frame.width
        self.scrollView.addSubview(UIView())
        contentWidth += view.frame.width
        self.scrollView.addSubview(UIView())
        contentWidth += view.frame.width
 */
        
        //self.scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        searchcontroller.searchBar.showsCancelButton = false
        searchcontroller.searchBar.clipsToBounds = true
        navigationItem.searchController = searchcontroller
        navigationItem.hidesSearchBarWhenScrolling = false
        searchcontroller.searchBar.delegate = self
        //searchcontroller.dimsBackgroundDuringPresentation = false
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.hidesNavigationBarDuringPresentation = false
        //navigationItem.title = "Weather"
        //setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = ""
        predictiontableView.isHidden = true
        
        /*
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        */
    
        var keys = UserDefaults.standard.dictionaryRepresentation().keys
        
        if let obj = UserDefaults.standard.object(forKey: "CITY ARRAY"){
            
        }
        else{
            var cityArray = [String]()
            UserDefaults.standard.set(cityArray,forKey:"CITY ARRAY")
        }
        
        var obj = UserDefaults.standard.object(forKey: "CITY ARRAY")as! Array<String>
        //print("obj elements =")
        //    for element in obj {
        //        print(element)
        //    }
        pageControl.numberOfPages = obj.count + 1
        
        /*
        for key in keys{
            print(key)
        }
 */
        
        //perform(#selector(setUpView), with: nil, afterDelay: 3)
        setUpView()
       // print("number of keys = \(keys.count)")
    }
    
    @objc func setUpView(){
        
        /*
        let obj1 = ViewController()
        let obj2 = FavouriteViewController()
        scrollView.contentSize = CGSize(width: 2 * view.frame.width, height: scrollView.frame.height)
        let frameVC = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        obj1.view.frame = frameVC
        obj2.view.frame = frameVC
        
        obj1.willMove(toParentViewController: self)
        obj2.willMove(toParentViewController: self)
        
        self.addChildViewController(obj1)
        self.addChildViewController(obj2)
        obj1.didMove(toParentViewController: self)
        scrollView.addSubview(obj1.view)
        obj2.didMove(toParentViewController: self)
        scrollView.addSubview(obj2.view)
         */
        
        //scrollView.addSubview(obj1.view)
        //scrollView.addSubview(obj2.view)
 
        var contentWidth: CGFloat = 0.0
        
         let controller1 = storyboard!.instantiateViewController(withIdentifier: "FirstView")as! ViewController
         //let controller1 = storyboard!.instantiateViewController(withIdentifier: "FirstView")
         controller1.city = "Los Angeles"
         //controller1.parentViewController = self
         self.addChildViewController(controller1)
        //controller1.view.frame = ...  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        scrollView.addSubview(controller1.view)
        let mainwidth = view.frame.width
        controller1.view.frame = CGRect(x: 0, y: 0, width: mainwidth, height: view.frame.size.height)
        controller1.didMove(toParentViewController: self)
        contentWidth += view.frame.width
        
        
        var obj = UserDefaults.standard.object(forKey: "CITY ARRAY")as! Array<String>
        pageControl.numberOfPages = obj.count + 1
        
        for element in obj {
            
        let controller2 = storyboard!.instantiateViewController(withIdentifier: "SecondView")as! SearchResultController
        controller2.flag2 = 1
        controller2.flag = 1
        controller2.parentView = self
        var cityInfo = UserDefaults.standard.object(forKey: element)as! [String: Any]
        controller2.city = cityInfo["city"] as! String
        controller2.photoUrl = cityInfo["photo-url"]as! String
        controller2.address =  cityInfo["address"]as! String
        self.addChildViewController(controller2)
        //controller1.view.frame = ...  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        scrollView.addSubview(controller2.view)
        controller2.view.frame = CGRect(x: contentWidth, y: 0, width: mainwidth, height: view.frame.size.height)
        controller2.didMove(toParentViewController: self)
        contentWidth += view.frame.width
        
    }

        /*
        
        let controller3 = storyboard!.instantiateViewController(withIdentifier: "SecondView")
        //self.addChildViewController(controller3)
        //controller1.view.frame = ...  // or, better, turn off `translatesAutoresizingMaskIntoConstraints` and then define constraints for this subview
        scrollView.addSubview(controller3.view)
        //controller3.didMove(toParentViewController: self)
        controller3.view.frame = CGRect(x: 1.05*contentWidth, y: 0, width: mainwidth, height: view.frame.height)
        contentWidth += view.frame.width
         */
        
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.size.height)
        //SVProgressHUD.dismiss()
        //actInd.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.predictions.count==0){
            predictiontableView.isHidden = true
        }
        else{
           predictiontableView.isHidden = false
        }
        return self.predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // print("In Table View = ")
       // print(self.predictions)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath)
        cell.textLabel?.text = self.predictions[indexPath.row]
        return cell
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //performSegue(withIdentifier: "SearchCall", sender: self)
        searchcontroller.searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
       // print("searchText = "+searchText)
        //var convertedSearchText = originalString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //let convertedSearchText = searchText.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        scrollView.isUserInteractionEnabled = true
        let originalString = "https://newproject-1573689447678.appspot.com/Autocomplete?keyword="+searchText
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        do{
            
            let mainurl = URL(string: urlString!)!
        
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
                   // print(self.predictions)
                    //[self.predictiontableView,performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true]
                    DispatchQueue.main.async(){
                    self.predictiontableView.reloadData()
                    }
                    //print(dict["predictions"])
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
            
        }
        catch {
        
        }
        
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("Search Text is= "+searchBar.text!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedText = self.predictions[indexPath.row]
        let array = selectedText.components(separatedBy: ",")
        print(array)
            city = array[0].trimmingCharacters(in: .whitespacesAndNewlines)
            for i in 0 ..< array.count {
                let entry = array[i].trimmingCharacters(in: .whitespacesAndNewlines)
                if(i==0){
                    wholeAddress = entry
                    address = entry
                }
                else{
                    wholeAddress = wholeAddress+" "+entry
                    address = address+entry
                }
                
            }
        
      wholeAddress = wholeAddress.replacingOccurrences(of: " ", with: "%20")
      address = address.replacingOccurrences(of: " ", with: "")
       // print("city is = "+city)
       // print("address is = "+address)
       // print("wholeaddress = "+wholeAddress)
        
        //self.predictiontableView.isHidden = true
       // print("selected text= "+self.predictions[indexPath.row])
        //SVProgressHUD.show(withStatus: "Loading..")
       //perform(#selector(runSegue), with: nil, afterDelay: 3)
       navigationItem.title = "Weather"
       predictiontableView.isHidden = true
       performSegue(withIdentifier: "SearchCall", sender: self)
        
    }
    
    @objc func runSegue() {
        performSegue(withIdentifier: "SearchCall", sender: self)
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected text= "+self.predictions[indexPath.row])
    }
 */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        performSegue(withIdentifier: "earchCall", sender: self)
    }
    
    func setTtitle(){
        navigationItem.title = "Weather"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        var vc = segue.destination as! SearchResultController
        if let obj = UserDefaults.standard.object(forKey: city) {
            vc.flag = 1
        }
        else{
            vc.flag = 0
        }
        //vc.parentView = self
        vc.flag2 = 0
        vc.address = address
        vc.photoUrl = wholeAddress
        vc.city = city
      
    }
 
    
    
}
