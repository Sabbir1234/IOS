//
//  ViewController.swift
//  PhotosApp
//
//  Created by Masud Saad on 30/11/20.
//

import UIKit
import PhotosUI

class ImageModel{
    var imageName: String
    var thumbPath: String
    var mainPath: String
    
    init(imageName: String, thumbPath: String, mainPath:String) {
        self.imageName = imageName
        self.thumbPath = thumbPath
        self.mainPath = mainPath
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var folderName : String?
    let fileManager = FileManager.default
    var items: [String] = []
    var imageModel: [ImageModel] = []
    let reuseIdentifier = "cell"
    
    func homeDirectory()->URL?{
        return self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func folderDirectory(for albumName: String)->URL?{
    
        return self.homeDirectory()?.appendingPathComponent(self.folderName!).appendingPathComponent(albumName)
    }
    
    func mainImageDirectory(for albumName: String,name: String)->URL?{
        
        return self.homeDirectory()?.appendingPathComponent(self.folderName!).appendingPathComponent(albumName).appendingPathComponent(name)
    }
    
    func thumbImageDirectory(for albumName: String,name: String)->URL?{
        
        return self.homeDirectory()?.appendingPathComponent(self.folderName!).appendingPathComponent(albumName).appendingPathComponent(name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let directoryPath = self.folderDirectory(for: "Main"), let thumbDirectoryPath =  self.folderDirectory(for: "Main_thumb"){
            do {
                try self.fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true, attributes: nil)
                try self.fileManager.createDirectory(at: thumbDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print(error.localizedDescription)
            }
            
        }
        
        self.title = self.folderName!
        
        self.loadImages()
    }
    
    private func loadImages(){
        if let directoryPath = self.folderDirectory(for: "Main"){
            do {
                let names = try self.fileManager.contentsOfDirectory(atPath: directoryPath.path).sorted{
                    (s1, s2) -> Bool in return s1.localizedStandardCompare(s2) == .orderedAscending
                }
                
                for name in names{
                    self.imageModel.append(ImageModel(imageName: name, thumbPath: self.mainImageDirectory(for: "Main_thumb", name: name)!.path, mainPath: self.mainImageDirectory(for: "Main", name: name)!.path))
                }
                print(imageModel.count)
                self.collectionView.reloadData()
                let lastIndexPath = IndexPath(row: self.imageModel.count - 1, section: 0)
                self.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
            } catch  {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    private func processPickerResult(results: [PHPickerResult]){
        
        if results.count > 0{
            
            let myGroup = DispatchGroup()
            self.activityIndicator.startAnimating()
            
            for phResult in results{
                
                myGroup.enter()
                if phResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    phResult.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            self.saveImage(image: image, thumbImage: image.resizeImage(maxHeight: 500, maxWidth: 500, compressionQuality: 1.0).getThumb(width: 200, height: 200), albumName: "Main"){ (finished, imageName) in
                                myGroup.leave()
                                DispatchQueue.main.async {
                                    if let name = imageName{
                                        print(name)
                                        self.imageModel.append(ImageModel(imageName: name, thumbPath: self.mainImageDirectory(for: "Main_thumb", name: name)!.path, mainPath: self.mainImageDirectory(for: "Main", name: name)!.path))
//                                        self.imageModel.insert(ImageModel(imageName: name, thumbPath: self.mainImageDirectory(for: "Main_thumb", name: name)!.path, mainPath: self.mainImageDirectory(for: "Main", name: name)!.path), at: 0)
                                        let lastIndexPath = IndexPath(row: self.imageModel.count - 1, section: 0)
                                        self.collectionView.insertItems(at: [lastIndexPath])
                                        self.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
                                    }
                                    
                                }
                            }
                            
                        }
                        else{
                            myGroup.leave()
                        }
                    }
                }
                else{
                    myGroup.leave()
                }
            }
            
            myGroup.notify(queue: .main) {
                print("Finished all tasks.")
                self.activityIndicator.stopAnimating()
                
            }
        }
    }

    
    let divide = {
       (val1: Int, val2: Int) -> Int in
       return val1 / val2
    }
    
    
    private func testCloser(completion: (_ finished: Bool) ->Void){
       completion(true)
    }
    
    private func getNewItemNumber() -> Int{
        
        

        if let itemNumber = UserDefaults.standard.integer(forKey: "itemNumber") as Int?{
            UserDefaults.standard.set(itemNumber + 1, forKey: "itemNumber")
            return itemNumber + 1
        }
        else{
            let itemNumber = 1
            UserDefaults.standard.set(itemNumber, forKey: "itemNumber")
            return itemNumber
        }
    }
    
    @IBAction func pick(sender: UIButton){
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    func test()-> String
    {
        if "" == ""
        {
            return ""
        }
        else{
            return "sf"
        }
    }
    
    func saveImage(image: UIImage, thumbImage: UIImage, albumName: String, withCompletionHandler: @escaping((finished: Bool, imageName: String?)) ->Void){
        
        if let imageData = image.jpegData(compressionQuality: 0.5), let thumbImagedata = thumbImage.jpegData(compressionQuality: 1.0){
            if let directoryPath = self.folderDirectory(for: albumName), let thumbDirectoryPath =  self.folderDirectory(for: "\(albumName)_thumb"){
                
                let imageName = "IMG\(self.getNewItemNumber()).jpg"
                let imagePath = directoryPath.appendingPathComponent(imageName)
                let thumbImagePath = thumbDirectoryPath.appendingPathComponent(imageName)
                
                if !self.fileManager.fileExists(atPath: imagePath.path){
                    do {
                        try imageData.write(to: imagePath)
                        try thumbImagedata.write(to: thumbImagePath)
                        withCompletionHandler((true,imageName))
                    } catch  {
                        print(error)
                        withCompletionHandler((false,nil))
                    }
                }
            }
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
        
        guard !results.isEmpty else { return }
        //self.phPickerResults = results
        self.processPickerResult(results: results)
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageModel.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        cell.imageView.image = UIImage(contentsOfFile: self.imageModel[indexPath.item].thumbPath)
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.row] // The row value is the same as the index of the desired text within the array.
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}



extension UIImage{
    func getThumb(width: Double, height: Double) -> UIImage {
        
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    
    func resizeImage(maxHeight: Float, maxWidth: Float, compressionQuality: Float) -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
}
