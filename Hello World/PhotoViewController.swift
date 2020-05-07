//
//  PhotoViewController.swift
//  Hello World
//
//  Created by Anshuman Misra on 30/11/19.
//  Copyright © 2019 Anshuman Misra. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class PhotoViewController : UIViewController{
    var cityTobeSearched : String!
    
    @IBOutlet var scroller: UIScrollView!
    //@IBOutlet var photoTable: UITableView!
    var imageURLS = [String]()
    
    var imageData = ["https://i.redd.it/snvrl97axmb11.jpg","https://upload.wikimedia.org/wikipedia/commons/8/89/Los_Angeles%2C_Winter_2016.jpg","https://airlines-airports.com/wp-content/uploads/2016/07/USA-Los-Angeles.jpg","https://upload.wikimedia.org/wikipedia/commons/3/30/Echo_Park_Lake_with_Downtown_Los_Angeles_Skyline.jpg","https://www.thepinnaclelist.com/wp-content/uploads/2018/05/02-Aerial-View-of-Office-Towers-Downtown-Los-Angeles-California-USA.jpg"]
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading..")
        let tabBar = tabBarController as! BaseTabBarController
        cityTobeSearched = tabBar.cityPhotos
        //setImage()
         getImages()
    }
    
    
    
    
    func setImage() {
        let numberOfImages = 5
        let imageViewHeight:CGFloat = 250.0
        scroller.contentSize = CGSize(width: view.frame.size.width, height: imageViewHeight*(CGFloat)(numberOfImages))
        
        var newY:CGFloat = 0
        
        for element in imageURLS {
        
            //let mainUrl = "https://upload.wikimedia.org/wikipedia/commons/8/89/Los_Angeles%2C_Winter_2016.jpg"
            //print(entry)
            if let url = URL(string: element){
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    let imageView = UIImageView(image: image)
                    //images.append(imageView)
                    imageView.frame = CGRect(x: 0, y: newY, width: view.frame.size.width, height: imageViewHeight)
                    newY = newY + CGFloat(imageViewHeight)
                    scroller.addSubview(imageView)
                }
                catch let error{
                    print("Error : \(error.localizedDescription)")
                }
                
            }
        }
        SVProgressHUD.dismiss()
    }
    
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.imageURLS.count
        //return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("came in table view")
          let mainUrl = self.imageURLS[indexPath.row]
        //let mainUrl = "https://upload.wikimedia.org/wikipedia/commons/8/89/Los_Angeles%2C_Winter_2016.jpg"
        //print(entry)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)as! ImageViewCell
        if let url = URL(string: mainUrl){
            do {
                let data = try Data(contentsOf: url)
            cell.photoImage.image = UIImage(data: data)
            }
            catch let error{
                print("Error : \(error.localizedDescription)")
            }
            
        }
        
        return cell
    }
 
    */
    
    
    
    func getImages(){
        //print(cityTobeSearched)
        var urlString = "https://newproject-1573689447678.appspot.com/CityImage?city="+cityTobeSearched
        let mainurl = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: mainurl) {(data, response, error) in
            
            guard let data = data else { return }
            do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let dict2 = json as? [String:Any]{
                    if let dict = dict2["items"] as? NSArray{
                        self.imageURLS = [String]()
                        for i in 0 ..< dict.count {
                            if let entry = dict[i] as? [String:Any]{
                                //print(entry["link"])
                                self.imageURLS.append(entry["link"]as! String)
                            }
                        }
                        DispatchQueue.main.async(){
                        //self.photoTable.reloadData()
                            self.setImage()
                        }
                    }
                }
            //print(json)
            }
            catch{
                print("JSON error: \(error.localizedDescription)")
            }
        }
            
        task.resume()
        
    }
}
