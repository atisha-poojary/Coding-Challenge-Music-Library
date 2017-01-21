//
//  ViewController.swift
//  Coding Challenge: Music Search
//
//  Created by Atisha Poojary on 20/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    var musicDictionary: NSDictionary!
    var resultArray: NSArray = []
    var filteredArray: NSArray = []
    
    var shouldShowSearchResults = false
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadListOfMusic() {

        let pathToFile = Bundle.main.url(forResource: "1", withExtension: "txt")
        let data = NSData(contentsOf: pathToFile!)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments)
            if let dict = json as? NSDictionary {
                self.musicDictionary = dict
                tableView.reloadData()
            }
        }
        catch let error as NSError {
            print("An error occurred: \(error)")
        }
    }
    
    func loadListOfMusic(searchText:String){
        let urlString = ("https://itunes.apple.com/search?term=\(searchText)")
        let url: URL = URL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                return
            }
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    
                    print("dict:'\(dict)")
                    
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        if let dict = json as? NSDictionary {
                            self.musicDictionary = dict
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                            }
                        }
                        else {
                            let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
                }
            } catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }

    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let searchPredicate = NSPredicate(format: "trackName contains %@", searchText)
        filteredArray = (self.musicDictionary["results"] as! NSArray).filtered(using: searchPredicate) as NSArray
        print("filteredArray \(filteredArray)")
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //self.filterContentForSearchText(searchText: searchController.searchBar.text!)
        let searchString = searchController.searchBar.text!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        self.loadListOfMusic(searchText: searchString)
    }


    //MARK: - Tableview Delegate & Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        if (self.musicDictionary != nil){
            return self.musicDictionary["resultCount"] as! Int
        }
        
//        if searchController.isActive && searchController.searchBar.text != "" {
//            return filteredArray.count
//        }
//        else {
//            if (self.musicDictionary != nil){
//                return self.musicDictionary["resultCount"] as! Int
//            }
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MusicCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "musicCustomCell") as! MusicCustomCell!)
        
        if (((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "artworkUrl100") as? String) != "" {
            cell.albumImage.imageFromUrl(urlString: (((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "artworkUrl60") as? String)!)
        }
        else {
            
        }
        
        
        if (((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "trackName") as? String) != "" {
            cell.trackName.text = ((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "trackName") as? String
            cell.trackName.adjustsFontSizeToFitWidth = true
        }
        else {
            cell.trackName.text = ""
        }
        
        if (((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "artistName") as? String) != "" {
            cell.artistName.text = ((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "artistName") as? String
            cell.artistName.adjustsFontSizeToFitWidth = true
        }
        else {
            cell.artistName.text = ""
        }
        
        if (((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "collectionName") as? String) != "" {
            cell.albumName.text = ((self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "collectionName") as? String
            cell.albumName.adjustsFontSizeToFitWidth = true
        }
        else {
            cell.albumName.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lyricsViewController") as! LyricsViewController
        vc.musicDictionary = (self.musicDictionary["results"] as! NSArray).object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        self.navigationController?.show(vc, sender: nil)
    }
}

//MARK: - Download image async
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

