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
    var myDocArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupTableView()
        self.getImageFromDocumentDirectory()
        self.setupTableView()
        
        
    }
    
    func setupTableView()
    {
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        favouriteTableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "CELL")
        favouriteTableView.tableFooterView = UIView.init()
    }
    
    func getImageFromDocumentDirectory(){
            
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("favourite")
        
            //let fileManager = FileManager.default
            let documentsURL = URL(fileURLWithPath: paths)
            do {
                
                let fileArray : NSArray = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) as NSArray
                myDocArray = fileArray.mutableCopy() as! NSMutableArray
                
               
                
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
            
            
          favouriteTableView.reloadData()
            
   
            
        }
    
    @IBAction func homeButtonTapped()
    {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func favouriteButtonTapped()
    {
        
    }
    

   
}

extension FavouriteViewController : UITableViewDelegate , UITableViewDataSource, FavouriteCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDocArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteTableViewCell = favouriteTableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath) as! FavouriteTableViewCell
        cell.delegate = self
        let imagePath: URL = myDocArray[indexPath.row] as! URL
        let image =  UIImage(contentsOfFile: imagePath.path)
        cell.favouriteImageView.image = image
        
        return cell
    }
    
    
    func  favouriteButtonTapped(cell: FavouriteTableViewCell) {
        let indexPath = self.favouriteTableView.indexPath(for: cell)
        let imagePath: URL = myDocArray[indexPath!.row] as! URL
        let imageName = imagePath.lastPathComponent
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("favourite")
        let pathURL = URL(fileURLWithPath: paths).appendingPathComponent(imageName)
        UserDefaults.standard.set("unMarked", forKey: imageName)
        
        do {
            try fileManager.removeItem(atPath: pathURL.path)
                    print("Local path removed successfully")
                } catch let error as NSError {
                    print("------Error",error.debugDescription)
                }
        myDocArray.removeObject(at: indexPath!.row)
        
        //favouriteTableView.deleteRows(at: [indexPathOne?.row], with: .bottom)
        
        favouriteTableView.reloadData()
        
        
        
    }
    
    
    
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {




    }

}
