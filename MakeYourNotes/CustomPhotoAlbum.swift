//
//  CustomPhotoAlbum.swift
//  SQLiteSwiftDem
//
//  Created by Anuj Mohan Saxena on 04/12/18.
//  Copyright © 2018 Anuj Mohan Saxena. All rights reserved.
//

import Foundation
import AssetsLibrary
import Photos
import UIKit

class CustomPhotoAlbum: NSObject {
   // static let albumName = "SqliteSwiftAnuj"
    var albumName = "SM"
    static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
           // self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        
        PHPhotoLibrary.shared().performChanges({
           /// PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)

            
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName) // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(error)")
            }
        }
    }
    
    
    func isFolderExist(Album:String)->Bool{
        var isExist = false
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        if exists {
            print("exist folder")
            isExist = true
        }
        else{
            print("not exist folder")
        }
        return isExist
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        
        
        let fetchOptions = PHFetchOptions()
       // fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject as! PHAssetCollection
        }
        return nil
    }
    
    func saveImage(image: UIImage)
    {
        if assetCollection == nil
        {
            return                 // if there was an error upstream, skip the save
        }
        
        /* old method
        PHPhotoLibrary.shared().performChanges({
            
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest.init(for: self.assetCollection)
            
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            //(for AssetCollection: self.assetCollection)
            // albumChangeRequest!.addAssets([assetPlaceHolder!])
        }, completionHandler: nil)
        
        */
        
        
        // working code of saving image and geting its url
         var imageUrl = ""
         var localId = ""
         PHPhotoLibrary.shared().performChanges({
         let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
         let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
         let albumChangeRequest = PHAssetCollectionChangeRequest.init(for: self.assetCollection)
         
         let enumeration: NSArray = [assetPlaceHolder!]
         albumChangeRequest!.addAssets(enumeration)
         localId = assetChangeRequest.placeholderForCreatedAsset?.localIdentifier ?? ""
         //(for AssetCollection: self.assetCollection)
         // albumChangeRequest!.addAssets([assetPlaceHolder!])
         }, completionHandler: { success, error in
         var assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil) as? PHFetchResult
         if !success {
         if let anError = error {
         print("Error creating asset: \(anError)")
         }
         } else {
         var assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil) as? PHFetchResult
         let imageManager = PHCachingImageManager()
         
         let asset = assetResult?.lastObject as! PHAsset
         print("Inside  If object is PHAsset, This is number 1")
         
         let imageSize = CGSize(width: asset.pixelWidth,
         height: asset.pixelHeight)
         
         /* For faster performance, and maybe degraded image */
         let options = PHImageRequestOptions()
         options.deliveryMode = .fastFormat
         options.isSynchronous = true
         options.isNetworkAccessAllowed = true
         
         imageManager.requestImage(for: asset,
         targetSize: imageSize,
         contentMode: .aspectFill,
         options: options,
         resultHandler: {
         (image, info) -> Void in
         //  self.photo = image!
         /* The image is now available to us */
         //  self.addImgToArray(uploadImage: self.photo!)
        
         print("enum for image, This is number 2")
         print("file path = \(info!["PHImageFileURLKey"])")
            
        //imageUrl = (info!["PHImageFileURLKey"] as! NSURL).relativeString
            
            CustomPhotoAlbum.getPHAssetURL(of: asset) { (phAssetUrl) in
              print("image url =\(phAssetUrl)")
                imageUrl = phAssetUrl!.relativeString
    
                var imageDataDict = [String: String]()
                 imageDataDict["image"] = imageUrl
                 imageDataDict["localIdentifier"] = localId
                let nc = NotificationCenter.default
                //nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
                nc.post(name: NSNotification.Name(rawValue: "UserLoggedIn"), object: nil, userInfo: imageDataDict)
                
                print("local identifier = \(localId)")
            }
            
             })
           }
         })
    }
    
    func getImageFromCustomImageFolder() ->String
    {
        var images = [Any].self
        
        let paths = NSSearchPathForDirectoriesInDomains( .documentDirectory
            , .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        var imagesDirectoryPath = documentDirectorPath + "/Name of Custom Album"
        print("iamge directorypath = \(imagesDirectoryPath)")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
        else
        {
            let imageUrl =  imagesDirectoryPath + "/Acorn_PNG739.png"
            var  filePath:NSURL? = nil
            filePath = NSURL.fileURL(withPath: imageUrl) as NSURL
            
            if filePath != nil
            {
                return imageUrl
            }
        }
        
        let mNsUrl = ""
        return mNsUrl
    }
    
    
    static func getPHAssetURL(of asset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void))
    {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            asset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
    }
    
    func fetchCustomAlbumPhotos()
    {
        let albumName = "Name of Custom Album"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset,
                                          targetSize: imageSize,
                                          contentMode: .aspectFill,
                                          options: options,
                                          resultHandler: {
                                            (image, info) -> Void in
                                            //  self.photo = image!
                                            /* The image is now available to us */
                                            //  self.addImgToArray(uploadImage: self.photo!)
                                            print("enum for image, This is number 2")
                                            print("file path = \(info!["PHImageFileURLKey"])")
                })
            }
        }
    }
    
//    func addImgToArray(uploadImage:UIImage)
//    {
//        // self.images.append(uploadImage)
//
//    }
    
}
