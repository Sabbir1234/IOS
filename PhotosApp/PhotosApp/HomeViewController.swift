//
//  HomeViewController.swift
//  PhotosApp
//
//  Created by Twinbit Limited on 1/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    let fileManager = FileManager.default
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var homeDirectory: URL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    var folders : [String] = []
    let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFolders()
    }
    
    //MARK: - PRIVATE FUNCTIONS
    private func loadFolders(){
        if let directoryPath = self.homeDirectory{
            do {
                self.folders = try self.fileManager.contentsOfDirectory(atPath: directoryPath.path)
                self.collectionView.reloadData()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCoverImage(folderName: String)->UIImage?{
        if let directory = self.homeDirectory?.appendingPathComponent(folderName).appendingPathComponent("Main_thumb"){
            do {
                let images = try self.fileManager.contentsOfDirectory(atPath: directory.path).sorted{
                    (s1, s2) -> Bool in return s1.localizedStandardCompare(s2) == .orderedDescending
                }
                if images.count > 0{
                    let imageDir = directory.appendingPathComponent(images[0])
                    return UIImage(contentsOfFile: imageDir.path)
                }
            } catch  {
                print(error.localizedDescription)
                return nil
            }
            
        }
        return nil
    }
   //MARK: - BUTTON ACTIONS
    @IBAction func makeFolder(){
        let alertController = UIAlertController(title: "Add New Folder", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Folder Name"
            textField.autocapitalizationType = .words
            }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
            if let directory = self.homeDirectory?.appendingPathComponent(firstTextField.text ?? ""){
                if !self.fileManager.fileExists(atPath: directory.path){
                    do {
                        try self.fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                        self.folders.insert(firstTextField.text!, at: 0)
                        self.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                    } catch  {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.folders.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        //cell.imageView.image = UIImage(contentsOfFile: self.imageModel[indexPath.item].thumbPath)
        //self.homeDirectory()?.appendingPathComponent(self.folderName!).appendingPathComponent(albumName)
        cell.imageView.image = self.getCoverImage(folderName: self.folders[indexPath.item])
        cell.nameLabel.text = self.folders[indexPath.item]
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let vc = storyboard!.instantiateViewController(identifier: "ViewController") as ViewController
        vc.folderName = self.folders[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)

        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:200, height: 200)
    }
}
