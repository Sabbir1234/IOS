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
    var myDocArray = NSMutableArray()
    var selectedFolderPath : String?
    var folderArray = [Folder]()
    var favArray = [Favourite]()
    var editTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavButton()
        folderArray = CoreDataManager.fetchData()
        
        
        
        self.setupCollectionView()
        //collectionView.reloadData()
        
        print("Welcome to File Manager")
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        editTag = 0
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
        if editTag == 1
        {
            return
        }
        
        var textFieldName = UITextField()
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let name = textFieldName.text!
            if name.count != 0
            {
                if CoreDataManager.fetchDataWithSameName(name: name).count > 0
                {
                    return
                }
                
                CoreDataManager.insertData(name : name, path: name)
                
                self.folderArray = CoreDataManager.fetchData()
                self.collectionView.reloadData()
            }
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel")
        
        }
        alert.addAction(action)
            alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input Your Folder Name"
            textFieldName = alertTextField
            
            
            self.present(alert,animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func favouriteAtHomeTapped()
    {
        if editTag == 0
        {
            let favouriteVC = self.storyboard?.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
            
            self.navigationController?.pushViewController(favouriteVC, animated: true)
        }
        
        
    }
    
    
    
    @IBAction func editAtHome()
    {
        if editTag == 0
        {
            editTag = 1
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else{
            editTag = 0;
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            
        }
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
        return CGSize(width: 77, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 56
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print(folderArray[indexPath.row].folder_path)
        
        self.selectedFolderPath = folderArray[indexPath.row].folder_name
        
        var folderName = folderArray[indexPath.row].folder_name!
        
        if editTag == 0
        {
            let imgVc = (self.storyboard?.instantiateViewController(identifier: "ImageViewController")) as! ImageViewController
            imgVc.delegate = self
            self.navigationController?.pushViewController(imgVc, animated: true)
        }
        else
        {
            
            
            
            let alertController = UIAlertController(title: "Rename or Delete", message: "It will be renamed or deleted permanently", preferredStyle: .alert)
                    
            let action1 = UIAlertAction(title: "Rename", style: .default) { (action:UIAlertAction) in
                
                var textFieldName = UITextField()
                let alert = UIAlertController(title: "Rename", message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    let name = textFieldName.text!
                    if name.count != 0
                    {
                        if CoreDataManager.fetchDataWithSameName(name: name).count > 0
                        {
                            return
                        }
                        
                        ImageDBManager.renameFolder(folder_name: self.selectedFolderPath!,newName: name)
                        CoreDataManager.updateData(folder_name: self.selectedFolderPath!,name: name)
                        self.folderArray = CoreDataManager.fetchData()
                        self.collectionView.reloadData()
                    }
                    
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                    print("You've pressed cancel")
                    
                    
                }

                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addTextField { (alertTextField) in
                    alertTextField.text = self.selectedFolderPath
                    textFieldName = alertTextField
                self.present(alert, animated: true, completion: nil)
                
                //ImageDBManager.renameFolder(folder_name: self.selectedFolderPath!)
                
                print("You've pressed renamed");
            }
            }
            let action2 = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
                
                ImageDBManager.deleteFoldersImage(folder_name: self.selectedFolderPath!)

                self.folderArray.remove(at: indexPath.row)
                CoreDataManager.deleteData(withIndex: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
                
                print("You've pressed the delete");
            }
            let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel")
                
                
            }

            

            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.addAction(action3)
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
            
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}



extension ViewController : ImageControllerDelegate{
    func getPath()->String {
        return selectedFolderPath!
    }
    
    
    
    
}
    

