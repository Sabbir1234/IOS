//
//  HomeViewController.swift
//  music_library
//
//  Created by Twinbit LTD on 22/11/20.
//

import UIKit



class HomeViewController: UIViewController {
    @IBOutlet  var homeCollectionView : UICollectionView!
    var sound = [SoundStory]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        getDataFromServer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func setUp()  {
        homeCollectionView.delegate  =  self
        homeCollectionView.dataSource = self
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CELL")
    }
    func getDataFromServer(){
            

          
            let url = URL(string: "http://3.6.206.113/SleepSound/getHomeCoverItems.php")!
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: { data, response, error -> Void in
               // print(response!)
                do {
                    if let data = data{
                      // print(data)
                        let arr = try? JSONDecoder().decode(Story.self,from: data)
                        
                        for  temp in arr?.soundstories ?? []
                        {
                            self.sound.append(temp)
                        }
                        
                        
                    }
                    else
                    {
                        return
                    }


                    DispatchQueue.main.async {
                        self.homeCollectionView.reloadData()
                    }


                } catch {
                    print("error")
                }
            })

            task.resume()
        }
    
    
    
    
    
}




extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sound.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! HomeCollectionViewCell
        
        cell.artistName.text = sound[indexPath.row].artistName
        cell.trackName.text = sound[indexPath.row].trackName
        cell.category.text = sound[indexPath.row].category
        cell.trackpath.text = sound[indexPath.row].trackPath
        cell.duration.text = "\(sound[indexPath.row].duration)"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 410, height: 300)
    }
    
}
