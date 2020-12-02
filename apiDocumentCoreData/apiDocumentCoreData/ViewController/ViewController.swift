//
//  ViewController.swift
//  apiDocumentCoreData
//
//  Created by Twinbit LTD on 2/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var folderCollectionView: UICollectionView!
    var myDocArray = NSMutableArray()
    var selectedFolderName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getFolderFromDocumentDirectory()
    }
    func setupCollectionView(){
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
      

        navigationItem.rightBarButtonItems = [add]
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
        folderCollectionView.register(UINib(nibName: "FolderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CELL")
    }
    
    @objc func addTapped()
    {
        
        let alert = UIAlertController(title: "Add New Folder",message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Folder Name"
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let name = alert.textFields?.first?.text {
                if name.count > 0
                {
                    let fileManager = FileManager.default
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
                    if !fileManager.fileExists(atPath: documentsDirectory.path) {
                        do {
                            try fileManager.createDirectory(atPath: documentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
                            self.myDocArray.add(documentsDirectory)
                            let lastIndexPath = IndexPath(row: self.myDocArray.count - 1, section: 0)
                            self.folderCollectionView.insertItems(at: [lastIndexPath])
                            self.folderCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
                            print("file is created")
                        } catch {
                            print("not created")
                            print(error.localizedDescription);
                        }
                    }
                    
                    
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
        
        
        
    }
    
    
    func getFolderFromDocumentDirectory(){
           
           let fileManager = FileManager.default
           let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
           do {
               
               let fileArray : NSArray = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) as NSArray
           
               myDocArray = fileArray.mutableCopy() as! NSMutableArray
            
            print("count is \(myDocArray.count)")
               
           } catch {
               print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
           }
           
           
           
           folderCollectionView.reloadData()
           
 
           
       }
    
    
    
    


}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myDocArray.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = folderCollectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath as IndexPath) as! FolderCollectionViewCell
        cell.folderImageView.image = UIImage(named: "home_icon")
        cell.folderLabel.text = (myDocArray[indexPath.item] as! URL).lastPathComponent
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 70, height: 80)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFolderName = (myDocArray[indexPath.item] as! URL).lastPathComponent
        let imageVC =  (self.storyboard?.instantiateViewController(identifier: "ImageViewController")) as! ImageViewController
        imageVC.delegate = self
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 5, left: 20, bottom: 10, right: 20)
        }

    
    
    
}

extension ViewController : ImageControllerDelegate
{
    
    
    func fun() {
        print("Delegate called")
    }
    
    
}





