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


class ImageViewController : UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet var addImageButton , saveButton : UIButton!
    @IBOutlet var nameTextField : UITextField!
    var selectedImage = UIImage()
    var myDocArray = NSMutableArray()
    var selectedFolderName = String()
    
    var delegate : ImageControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBarButton()
        self.setupTableView()
        self.getImageFromDocumentDirectory()
        tableView.reloadData()
        selectedFolderName = self.delegate.getPath()
        print("selected folder path")
        print(selectedFolderName)
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(selectedFolderName)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getImageFromDocumentDirectory()
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
    
    func marked()
    {
        
    }
    
    @objc func didTapAddButton(sender: AnyObject){
        
        //print("add")
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let image = UIImagePickerController()
            image.delegate = self
            self.present(image, animated: true, completion: nil)
            
            //print("After present")
        }
        
        //saveImageintoDocumentDirectory()
        
        
        
        
    }
    
    func saveImageintoDocumentDirectory()
    {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let fileName = "\(year)-\(month)-\(day)-\(hour)-\(minutes)-\(seconds).jpg"
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(selectedFolderName )
        let imageData = self.selectedImage.jpegData(compressionQuality: 1.0)
        let pathURL = URL(fileURLWithPath: paths).appendingPathComponent(fileName)
        
        fileManager.createFile(atPath: pathURL.path, contents: imageData, attributes: nil)
        
        
        self.getImageFromDocumentDirectory()
                        
        print(paths)
       
        
        
    }
    
    func getImageFromDocumentDirectory(){
            
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString).appendingPathComponent(selectedFolderName )
        
            //let fileManager = FileManager.default
            let documentsURL = URL(fileURLWithPath: paths)
            do {
                
                let fileArray : NSArray = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) as NSArray
            
                myDocArray = fileArray.mutableCopy() as! NSMutableArray
                
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
            
            
          tableView.reloadData()
            
   
            
        }
    
    
    
    
    
    
    
    
    @objc func didTapEditButton(sender: AnyObject){
        print("edit")
    }
    
}





extension ImageViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDocArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "CELL",for: indexPath)as! TableViewCell
        let imagePath: URL = myDocArray[indexPath.row] as! URL
        let image =  UIImage(contentsOfFile: imagePath.path)
        cell.coverImageView.image = image
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        cell.dateLabel.text =  "\(day)- \(month) - \(year) "
        if cell.mark == 0
        {
            cell.starButton.setBackgroundImage(UIImage(named: "start_icon"), for: UIControl.State.normal)
        }
        else
        {
            cell.starButton.setBackgroundImage(UIImage(named: "startMark"), for: UIControl.State.normal)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        
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
        
    }
    
    
    
    
    
    
}
