//
//  ImageViewController.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 12/11/20.
//

import UIKit
protocol ImageControllerDelegate {
    func getPath()->String
}


class ImageViewController : UIViewController  {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var barItem : UIBarItem!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var addImageButton , saveButton , homeButton , favouriteButton : UIButton!
    @IBOutlet var nameTextField : UITextField!
    var selectedImage = UIImage()
    var myDocArray = NSMutableArray()
    var selectedFolderName = String()
    var favArray = [ImageDB]()
    var imageArray = [ImageDB]()
    var delegate : ImageControllerDelegate!
    var indexForCell : Int!
    var editTag = 0
    var indexPath = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFolderName = self.delegate.getPath()
        
        imageArray = ImageDBManager.fetchFolderImage(folder_name: selectedFolderName)
        self.setupBarButton()
        self.setupTableView()
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(selectedFolderName)
        
        navigationItem.title =   "Folder Name: \(selectedFolderName)"
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedFolderName = self.delegate.getPath()
        if editTag == 1
        {
            navigationItem.hidesBackButton = true
        }
        tableView.reloadData()
        
    }
    func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CELL")
        tableView.tableFooterView = UIView.init()
    }
    func setupBarButton()
    {
        let addButton = UIBarButtonItem(title: "Add",  style: .plain, target: self, action: #selector(didTapAddButton(sender:)))
        let editButton   = UIBarButtonItem(title: "Edit",  style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
        navigationItem.rightBarButtonItems = [editButton , addButton]
    }
    
    
    
    
    
    @IBAction func favouriteButtonTapped()
    {
        print("got")
        if editTag == 1
        {
            return
        }
        let favouriteVC = self.storyboard?.instantiateViewController(identifier: "FavouriteViewController") as! FavouriteViewController
        favouriteVC.modalPresentationStyle = .fullScreen
        favouriteVC.delegate = self
        self.present(favouriteVC, animated: true, completion: nil)
        
    }
    
    
    @objc func didTapHomeButton(sender: AnyObject)
    {
        if editTag == 1
        {
            return
        }
        print("tapped home")
    }
    
    
    @objc func didTapAddButton(sender: AnyObject){
        
        //print("add")
        
        if editTag == 1
        {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let image = UIImagePickerController()
            image.delegate = self
            self.present(image, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    
    
    func saveImageintoDocumentDirectory()
    {
        
        let obj = Helper()
        let fileName = obj.getUniqueName()
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(fileName)
        let imageData = self.selectedImage.jpegData(compressionQuality: 1.0)
        
        fileManager.createFile(atPath: paths, contents: imageData, attributes: nil)
        
        
        ImageDBManager.insertData(folder_name: selectedFolderName, image_name: fileName,icon_name: "star_icon")
        
        imageArray = ImageDBManager.fetchFolderImage(folder_name: self.selectedFolderName)
        
        tableView.reloadData()
        
        print(paths)
        
        
        
    }
    
  
    @objc func didTapEditButton(sender: AnyObject){
        if editTag == 0
        {
            editTag = 1
            navigationItem.rightBarButtonItems?[0].title = "Done"
            navigationItem.hidesBackButton = true
            //UITabBarController.tabBar.userInteractionEnabled = NO;
            if let items =  self.tabBarController?.tabBar.items {

                    for i in 0 ..< items.count {

                        let itemToDisable = items[i]
                        itemToDisable.isEnabled = false

                    }
                }

        }
        else{
            editTag = 0
            navigationItem.rightBarButtonItems?[0].title = "Edit"
            navigationItem.hidesBackButton = false
            if let items =  self.tabBarController?.tabBar.items {

                    for i in 0 ..< items.count {

                        let itemToDisable = items[i]
                        itemToDisable.isEnabled = true

                    }
                }
            
        }
    }
    
}





extension ImageViewController : UITableViewDelegate , UITableViewDataSource , MyCellDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath)as! TableViewCell
        cell.delegate = self
        tableView.reloadRows(at: [indexPath], with: .fade)
        let imageName = imageArray[indexPath.row].image_name
        let iconName = imageArray[indexPath.row].icon_name
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName!)
        
        let image =  UIImage(contentsOfFile: fileURL.path)
        cell.coverImageView.image = image
        cell.starButton.setBackgroundImage(UIImage(named: iconName!), for: UIControl.State.normal)
        
        cell.dateLabel.text = fileName
        
        //tableView.reloadData()
        return cell
    }
    
    
    func favouriteButtonTapped(cell: TableViewCell)  {

        if editTag == 1
        {
           return
        }
        
        

        self.indexPath = self.tableView.indexPath(for: cell)!

        

        let imageName = imageArray[indexPath.row].image_name!
        if(isKeyPresentInUserDefaults(key: imageName)) {

            if UserDefaults.standard.string(forKey: imageName) == "mark"
            {
                UserDefaults.standard.set("unmark", forKey: imageName)
                print("unmarked")
                cell.starButton.setBackgroundImage(UIImage(named: "start_icon"), for: UIControl.State.normal)
               
            }
            else{
                UserDefaults.standard.set("mark", forKey: imageName)
                print("marked")
                cell.starButton.setBackgroundImage(UIImage(named: "startMark"), for: UIControl.State.normal)
                
            }

        }else {
            UserDefaults.standard.set("mark", forKey: imageName)
            print("marked")
            cell.starButton.setBackgroundImage(UIImage(named: "startMark"), for: UIControl.State.normal)
        }
        ImageDBManager.updateIcon(image_name: imageName)
        imageArray = ImageDBManager.fetchFolderImage(folder_name: selectedFolderName)
        
        
        let indexPathRow: Int = indexPath.row
        let indexPosition = IndexPath(row: indexPathRow, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPosition], with: UITableView.RowAnimation.fade)
        self.tableView.endUpdates()
        

    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  
        if editTag == 1
        {
            
            if editingStyle == .delete
            {
                    let imageName = imageArray[indexPath.row].image_name!
                    imageArray.remove(at: indexPath.row)
                    ImageDBManager.deleteData(withIndex: indexPath.row)
                    removeImageLocalPath(localPathName: imageName)
                    if UserDefaults.standard.string(forKey: imageName) == "marked"
                    {
                        UserDefaults.standard.set("unMarked", forKey: imageName)
                    }
                    tableView.deleteRows(at: [indexPath], with: .bottom)
            }
            
        }
        
}
    
    func removeImageLocalPath(localPathName : String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = localPathName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path)
        {
            do{
                try fileManager.removeItem(atPath: fileURL.path)
            }
            catch
            {
                print("Could not clear temp folder: \(error)")
            }
        }
    }
    
}



extension ImageViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage
        {
            self.selectedImage = image
            self.saveImageintoDocumentDirectory()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageViewController : takeFromImageViewController
{
    func getFolderName() -> String
    {
        return selectedFolderName
    }
}
