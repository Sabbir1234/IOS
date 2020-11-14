//
//  FavouriteViewController.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 14/11/20.
//

import UIKit

class FavouriteViewController: UIViewController {

    @IBOutlet weak var favouriteTableView : UITableView!
    @IBOutlet weak var homeButton , favouriteButton : UIButton!
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
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent("favourite")
        
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

extension FavouriteViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDocArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteTableViewCell = favouriteTableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath) as! FavouriteTableViewCell

        let imagePath: URL = myDocArray[indexPath.row] as! URL
        let image =  UIImage(contentsOfFile: imagePath.path)
        cell.favouriteImageView.image = image
        

        return cell
    }
    
    

    
    
    
    
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {




    }

}
