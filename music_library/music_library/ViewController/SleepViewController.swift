//
//  SleepViewController.swift
//  music_library
//
//  Created by Twinbit LTD on 22/11/20.
//

import UIKit
import AVFoundation









class SleepViewController: UIViewController {
    
    @IBOutlet var headingCollectionView : UICollectionView!
    
    @IBOutlet var bottomTableView : UITableView!
    
    @IBOutlet var pauseButton : UIButton!
    
    var player: AVPlayer?
    
    var headerList = [Subcategory]()
    var indx : Int = 0
    var bottomListArray = [Sleepcategory]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        getDataToHeaderFromServer()
        //getDataToFooter()
        
        
    }
    
    
    func setUp()  {
        headingCollectionView.delegate  =  self
        headingCollectionView.dataSource = self
        headingCollectionView.register(UINib(nibName: "HeadingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CELL")
        
        bottomTableView.delegate  =  self
        bottomTableView.dataSource = self
        bottomTableView.register(UINib(nibName: "BottomTableViewCell", bundle: nil), forCellReuseIdentifier: "CELL")
        
        
        
        
    }
    @IBAction func pauseButtonTapped()
    {
        
        if player?.rate == 1
        {
            player?.pause()
            pauseButton.setTitle("Play", for: UIControl.State.normal)
        }
        else{
            
            player?.play()
            pauseButton.setTitle("Pause", for: UIControl.State.normal)
            
        }
        
    }
    func getDataToFooter()
    {
        print("index \(indx)")
        print(headerList.count)
        let str = headerList[indx].name
        var newGetSubCategories = str
        newGetSubCategories = newGetSubCategories.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
        let url = URL(string: "http://3.6.206.113/SleepSound/getSleepSoundList.php?category=sleep&subcategory=\(newGetSubCategories)")!
        
        print("footer url")
        print(url)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                if let data = data{
                    print(data)
                    let arr = try? JSONDecoder().decode(BottomList.self,from: data)
                    print("array for footer")
                    print("---------------------")
                    print(arr!)
                    print("---------------------")
                    
                    for temp in arr?.sleepsounds ?? []{
                        var obj = Sleepcategory()
                        obj.artistName =  temp.artistName
                        obj.trackName = temp.trackName
                        obj.trackPath = temp.trackPath
                        self.bottomListArray.append(obj)
                        
                        
                    }
                    
                    
                    
                }
                else
                {
                    return
                }
                DispatchQueue.main.async {
                    self.bottomTableView.reloadData()
                }
                
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
        
        
    }
    
   
    
    func getDataToHeaderFromServer(){
        
        
        var url = URL(string: "http://3.6.206.113/SleepSound/getSubCategoryList.php?category=sleep")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            // print(response!)
            do {
                if let data = data{
                    print(data)
                    let arr = try? JSONDecoder().decode(Welcome.self,from: data)
                    print("array")
                    print("---------------------")
                    print(arr)
                    print("---------------------")
                    
                    for temp in arr?.categories ?? []{
                        print("------Second Loop-------")
                        for temp1 in temp.subcategories
                        {
                            self.headerList.append(temp1)
                        }
                        
                        
                    }
                    
                    
                    
                }
                else
                {
                    return
                }
                
                
                DispatchQueue.main.async {
                    self.headingCollectionView.reloadData()
                    self.getDataToFooter()
                }
                
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
        
    }
    
    
    
    
}

extension SleepViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell : HeadingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! HeadingCollectionViewCell
        cell.nameLabel.text = headerList[indexPath.row].name
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        indx = indexPath.row
        print("did select item index \(indx)")
        bottomListArray.removeAll()
        getDataToFooter()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 100)
    }
    
}


extension SleepViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : BottomTableViewCell = bottomTableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! BottomTableViewCell
        
        cell.artistName.text = bottomListArray[indexPath.row].artistName
        cell.trackName.text = bottomListArray[indexPath.row].trackName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pauseButton.setTitle("Pause", for: UIControl.State.normal)
        
        let url : NSString = bottomListArray[indexPath.row].trackPath as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let surl : NSURL = NSURL(string: urlStr as String)!
        let playerItem = AVPlayerItem(url : surl as URL)
        
        self.player = try AVPlayer(playerItem:playerItem)
        
        print("Playing")
        player?.play()
        
    }
    
    
    
}



