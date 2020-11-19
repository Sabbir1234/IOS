//
//  FavouriteViewController.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 14/11/20.
//

import UIKit
protocol  takeFromImageViewController {
    func getFolderName() -> String
}

class FavouriteViewController: UIViewController {

    @IBOutlet weak var favouriteTableView : UITableView!
    @IBOutlet weak var homeButton , favouriteButton : UIButton!
    var delegate : takeFromImageViewController!
    
    var editTag = 0
//   var favArray = [Favourite]()
    var favArray = [ImageDB]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        favArray = ImageDBManager.fetchFavouriteImage(icon_name: "starMark")
            //favouriteTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favArray = ImageDBManager.fetchFavouriteImage(icon_name: "starMark")
        self.setupTableView()
        favouriteTableView.reloadData()
    }
    
   
    
    
    func setupTableView()
    {
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        favouriteTableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "CELL")
        favouriteTableView.tableFooterView = UIView.init()
    }
    
   
    
    @IBAction func homeButtonTapped()
    {
        if let nav = self.navigationController {
            self.dismiss(animated: true, completion: nil)
                    nav.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func favouriteButtonTapped()
    {
        
    }
    

   
}

extension FavouriteViewController : UITableViewDelegate , UITableViewDataSource, FavouriteCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteTableViewCell = favouriteTableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath) as! FavouriteTableViewCell
        
        cell.delegate = self
        let obj = favArray[indexPath.row]
        let imageName = obj.image_name!
        //let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(imageName)
        
        let image = UIImage(contentsOfFile: paths)
        
        cell.favouriteImageView.image = image
        
        cell.starButton.setBackgroundImage(UIImage(named: "starMark"), for: UIControl.State.normal)
        cell.imageNameLabel.text = imageName
        
        return cell
    }
    
    
    func  favouriteButtonTapped(cell: FavouriteTableViewCell) {
        let indexPath = self.favouriteTableView.indexPath(for: cell)
        let obj = favArray[indexPath!.row]
        let imageName = obj.image_name!
        UserDefaults.standard.set("unMarked", forKey: imageName)
        ImageDBManager.updateIcon(image_name: imageName)
        favArray = ImageDBManager.fetchFavouriteImage(icon_name: "starMark")
        favouriteTableView.reloadData()
        
        
        
    }
    
    
    
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {




    }

}
