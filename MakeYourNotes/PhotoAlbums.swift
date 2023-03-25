//
//  PhotoAlbums.swift
//  MakeYourNotes
//
//  Created by Anuj Mohan Saxena on 15/10/21.
//

import Foundation
import Photos
import UIKit

class PhotoManager {
    static let instance = PhotoManager()
    var folder: PHCollectionList?

    /// Fetches an existing folder with the specified identifier or creates one with the specified name
    func fetchFolderWithIdentifier(_ identifier: String, name: String) {
        let fetchResult = PHCollectionList.fetchCollectionLists(withLocalIdentifiers: [identifier], options: nil)
        guard let folder = fetchResult.firstObject else {
            createFolderWithName(name)
            return
        }
        self.folder = folder
    }

    /// Creates a folder with the specified name
    private func createFolderWithName(_ name: String) {
        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let changeRequest = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: name)
            placeholder = changeRequest.placeholderForCreatedCollectionList
        }) { (success, error) in
            guard let placeholder = placeholder else { return }
            let fetchResult = PHCollectionList.fetchCollectionLists(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            guard let folder = fetchResult.firstObject else { return }

            self.folder = folder
        }
    }

    /// Creates an album with the specified name
    private func createAlbumWithName(_ name: String, completion: @escaping (PHAssetCollection?) -> Void) {
        guard let folder = folder else {
            completion(nil)
            return
        }

        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let listRequest = PHCollectionListChangeRequest(for: folder)
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            listRequest?.addChildCollections([createAlbumRequest.placeholderForCreatedAssetCollection] as NSArray)
            placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }) { (success, error) in
            guard let placeholder = placeholder else {
                completion(nil)
                return
            }

            let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
            let album = fetchResult.firstObject
            completion(album)
        }
    }

    /// Saves the image to a new album with the specified name
    func saveImageToAlbumInRootFolder(_ albumName: String, image: UIImage?, completion: @escaping (Error?) -> Void) {
        createAlbumWithName(albumName) { (album) in
            guard let album = album else {
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset!
                albumChangeRequest?.addAssets([photoPlaceholder] as NSArray)
            }, completionHandler: { (success, error) in
                if success {
                    completion(nil)
                } else if let error = error {
                    // Failed with error
                } else {
                    // Failed with no error
                }
            })
        }
    }
}
