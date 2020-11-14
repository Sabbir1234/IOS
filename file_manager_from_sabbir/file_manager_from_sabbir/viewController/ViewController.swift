//
//  ViewController.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 11/11/20.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var homeLabel , favLabel : UILabel!
    @IBOutlet weak var favouriteButton : UIButton!
    var selectedFolderPath : String?
    var folderArray = [Folder]()
    var editTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavButton()
        self.setupCollectionView()
        folderArray = CoreDataManager.fetchData()
        collectionView.reloadData()
        
        print("hello")
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavButton()
        self.collectionView.reloadData()
    }
    
    
    func setNavButton()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Create",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(createAtHome))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(editAtHome))
        
        
    }
    @objc func createAtHome()
    {
        var textFieldName = UITextField()
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let name = textFieldName.text!
            if name.count != 0
            {
            // document directory
            
            let fileManager = FileManager.default

            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
            if !fileManager.fileExists(atPath: paths){
                try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
                print("Dir \(paths)")
                CoreDataManager.insertData(name : name, path: "\(paths)")
            }else{
                print("Already taken")
            }
      //      let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
//            let context = appDelegate.persistentContainer.viewContext
//            let entity = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context) as! Folder
//
//            entity.folder_name = name
//            entity.folder_path = "\(paths)"
//            self.folderArray.append(entity)
            
            self.folderArray = CoreDataManager.fetchData()
            self.collectionView.reloadData()
            }
            
            
        }
        
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input Your Folder Name"
            textFieldName = alertTextField
            
            
            self.present(alert,animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    @IBAction func favouriteAtHomeTapped()
    {
        
        let favouriteVC = self.storyboard?.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        
        self.navigationController?.pushViewController(favouriteVC, animated: true)
        
        
    }
    
    
    
    @IBAction func editAtHome()
    {
        print("Edit Tapped")
    }
    
    
    
    func setupCollectionView()
    {
        collectionView.delegate  =  self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    
}


extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.folderIcon.image = UIImage(named: "folder")
        cell.folderNameLabel.text = folderArray[indexPath.row].folder_name
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print(folderArray[indexPath.row].folder_path)
        
        self.selectedFolderPath = folderArray[indexPath.row].folder_name
        
        if editTag == 0
        {
            let imgVc = (self.storyboard?.instantiateViewController(identifier: "ImageViewController")) as! ImageViewController
            imgVc.delegate = self
            self.navigationController?.pushViewController(imgVc, animated: true)
        }
    }
    
    
    
    
    
    
    
    
    
}



extension ViewController : ImageControllerDelegate{
    func getPath()->String {
        return selectedFolderPath!
    }
    
    
    
    
}
