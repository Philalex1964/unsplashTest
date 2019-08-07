//
//  PhotoService.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/4/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Alamofire
import MagicalRecord

class PhotoService {
    
    static let shared = PhotoService() 
    
    public func getPhotos(completion: ((Swift.Result<[Photo], Error>) -> Void)? = nil) {
        let query = searchText
        let baseUrl = "https://api.unsplash.com"
        let path = "/search/photos"
        
        let params: Parameters = [
            "client_id": "df323d9b6f1542e39224aed966bd4baf6c24ec14248f09b403a7dea55dfac24d",
            "query": query,
            "page": 1,
            "per_page": 30,
//            "fit": "clip",
//            "w": 180,
//            "h": 180,
            "auto": "format"
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photos = json["results"].arrayValue.map { Photo($0) }
                print(json)
                print(query)
                let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
                let context = appDelegate!.persistentContainer.viewContext
                
                let oldIdentifiers = NSMutableArray()
                if let allPhotos : [PhotoMO] = self.allPhotosIn(context: context) {
                    for oldPhoto in allPhotos {
                        if oldPhoto.selectedPhoto {
                            oldIdentifiers.add("\(oldPhoto.photoDescription ?? "")\(oldPhoto.author ?? "")")
                        }
                    }
                }
                
                self.deletePhotosIn(context: context)
                let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)!
                for plainPhoto: Photo in photos {
                    let managedPhoto = PhotoMO(entity: entity,
                                             insertInto: context)
                    
                    managedPhoto.photoDescription = plainPhoto.photoDescription
                    managedPhoto.author = plainPhoto.author
                    managedPhoto.photoURL = plainPhoto.photoURL
                    managedPhoto.photoID = plainPhoto.photoID
                    
                    let identifier = "\(plainPhoto.photoDescription)\(plainPhoto.author)"
                    if oldIdentifiers.contains(identifier) {
                        managedPhoto.selectedPhoto = true
                    }
                }
                AppDelegate.shared.saveContext()
                completion?(.success(photos))
              
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
    
    public func allPhotosIn(context:NSManagedObjectContext) -> [PhotoMO]? {
        let fetchRequest: NSFetchRequest<PhotoMO> = PhotoMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "photoDescription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        return fetchResultsController.fetchedObjects
    }
    
    public func deletePhotosIn(context : NSManagedObjectContext) {
        if let fetchedObjects = self.allPhotosIn(context: context) {
            for photo in fetchedObjects {
                context.delete(photo)
            }
        }
    }
}

