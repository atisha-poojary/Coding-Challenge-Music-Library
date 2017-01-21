//
//  LyricsViewController.swift
//  Coding Challenge: Music Search
//
//  Created by Atisha Poojary on 21/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    var musicDictionary: NSDictionary!
    var songDictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        albumImage.imageFromUrl(urlString: self.musicDictionary["artworkUrl30"] as! String)
        
        let trackNameString: String
        let artistNameString: String
        
        if (self.musicDictionary["trackName"] as? String != "") && (self.musicDictionary["artistName"] as? String != ""){
            trackName.text = self.musicDictionary["trackName"] as? String
            trackNameString = (trackName.text)!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            
            artistName.text = self.musicDictionary["artistName"] as? String
            artistNameString = (artistName.text)!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            
             self.loadLyrics(artistName: artistNameString,trackName: trackNameString)
        }
        
        if (self.musicDictionary["collectionName"] as? String != ""){
            albumName.text = self.musicDictionary["collectionName"] as? String
        }
        
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLyrics(artistName:String, trackName:String){
        let urlString = ("http://lyrics.wikia.com/api.php?func=getSong&artist=\(artistName)&song=\(trackName)&fmt=json.json")
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
                let json = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
                
                if let dict = json as? NSDictionary {
                    
                    print("dict:'\(dict)")
                    
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        if let dict = json as? NSDictionary {
                            let artist = dict["artist"]
                            print("artist\(artist)")
                            
//                            song = {
//                                'artist':'Tom Waits',
//                                'song':'New Coat Of Paint',
//                                'lyrics':'Let\'s put a new coat of paint on this lonesome old town\nSet \'em up, we\'ll be knockin\' em [...]',
//                                'url':'http://lyrics.wikia.com/Tom_Waits:New_Coat_Of_Paint'
//                            }
                            
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
