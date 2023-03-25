//
//  ViewController.swift
//  MakeYourNotes
//
//  Created by Anuj Mohan Saxena on 24/09/21.
//

import UIKit
import Photos

class ViewController: BaseViewController {

    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var txt_Subject: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBManager.shared.createSubjectTable()
        DBManager.shared.getSubjects()
        CustomPhotoAlbum.sharedInstance.albumName = "Ram"
        CustomPhotoAlbum.sharedInstance.createAlbum()

        
        let chkString : String? = "AET"

        let fileManager = FileManager.default

        do {
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imagesFolderURL = documentDirectoryURL.appendingPathComponent("images/\(chkString!)")
            let imageURL = imagesFolderURL.appendingPathComponent("1.jpg")

            let image =  UIImage(named: "bell.jpg")

            if !fileManager.fileExists(atPath: imagesFolderURL.path){
                try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
            } else {
                print("Already dictionary created.")
            }
            let imageData = image!.jpegData(compressionQuality: 0.5)
            try imageData!.write(to: imageURL)

            print("imagePath =", imageURL.path)
        } catch {
            print(error)
        }
        
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        var DirPath2 = DocumentDirectory.appendingPathComponent("FOLDER_NAME")
        var DirPath = DirPath2!.appendingPathComponent("FOLDER_NAME2")
        do
        {
            try FileManager.default.createDirectory(atPath: DirPath.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        
        do {
            // get the documents directory url
          
            let fileName = UIImage(named: "name.jpg")
            // create the destination file url to save your image
            let fileURL = DirPath
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = fileName?.jpegData(compressionQuality:  1),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            }
        } catch {
            print("error:", error)
        }
        print("Dir Path = \(DirPath)")
        
        
        let image = UIImage.init(named: "bell")
        
        saveImage(image: image!)
        
        
        // add the shadow to the base view
        currentView.layer.borderWidth = 1
        currentView.layer.borderColor = UIColor.black.cgColor
//        currentView.clipsToBounds = true
//        currentView.layer.masksToBounds = false
        currentView.backgroundColor = UIColor.clear
        currentView.layer.shadowColor = UIColor.black.cgColor
        currentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        currentView.layer.shadowOpacity = 0.7
        currentView.layer.shadowRadius = 4.0
        // Do any additional setup after loading the view.
        
       
//       let defaults = UserDefaults.standard
//            let identifier = defaults.string(forKey: "myFolder")!
//        PhotoManager.instance.fetchFolderWithIdentifier(identifier, name: "My Folder")
//        PhotoManager.instance.saveImageToAlbumInRootFolder("My Album", image: UIImage(named: "my_image")) { (error) in
//             // Handle error
//        }
//
        
        self.saveDocumentInDocumentDir()
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func saveDocumentInDocumentDir(){
        let str = "Test Message"
               let url = getDocumentsDirectory().appendingPathComponent("message.txt")

               do {
                   try str.write(to: url, atomically: true, encoding: .utf8)
                   let input = try String(contentsOf: url)
                   print("path of txt = \(url.absoluteString)")
                   print(input)
               } catch {
                   print(error.localizedDescription)
               }
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }

    @IBAction func createAction(_ sender: UIButton) {
        if sender.tag == 101{
            self.openSubjectPopUp()
        }
        else if sender.tag == 102{
            self.openChapterPopUp()
        }
        else if sender.tag == 201{
            if txt_Subject.text?.count ?? 0 > 0{
            let m = CustomPhotoAlbum()
            m.albumName =  txt_Subject.text!
            m.createAlbum()
            }
            else{
                print("text not found ")
            }
        }
    }
    
    func openSubjectPopUp(){
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Create Your Subject", message: "name subject name", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Name"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // this code runs when the user hits the "save" button

            let inputName = alertController.textFields![0].text

            print(inputName!)
            
            if let name = inputName{
            let album = CustomPhotoAlbum()
            album.albumName = name
            album.createAlbum()
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func openChapterPopUp(){
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Create Your Chapter", message: "chapter name", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Name"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // this code runs when the user hits the "save" button

            let inputName = alertController.textFields![0].text

            print(inputName!)

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
}

