//
//  PhotoCollectionViewController.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/2/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher



class PhotoCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate,  UISearchBarDelegate  {
    
    @IBOutlet var photoCView: UICollectionView!

    public var photos: [PhotoMO] = []
    public var photoImage: UIImage?
    
    var searchController = UISearchController(searchResultsController: nil)
    //var searchBar = UISearchBar.self
    //public var searchText: String = ""
    
    lazy var fetchResultsController: NSFetchedResultsController<PhotoMO>? = {
        let fetchRequest: NSFetchRequest<PhotoMO> = PhotoMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "author", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let appDelegate : AppDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let fetchResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            photos = fetchedObjects
        }
        photoCView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: searchText)
//        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
//    }
//
//    @objc func search () {
//
//        PhotoService.shared.getPhotos(searchText: searchController.searchBar.text)
//
//    }

//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchController.searchBar.text = searchText
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: searchText)
//        self.perform(#selector(self.search), with: nil, afterDelay: 2.0)
//    }
//
//    @objc func search () {
//        PhotoService.shared.getPhotos(searchText: searchController.searchBar.text)
//
//    }
    public func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
//        searchBar.delegate = self
        PhotoService.shared.getPhotos(searchText: searchText)
        photoCView.reloadData()
            }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? PhotoCustomLayout {
            layout.delegate = self
        }
        
        searchController.searchBar.delegate = self
        PhotoService.shared.getPhotos(searchText: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.setShowsCancelButton(true, animated: true)
 //       searchController.searchBar.text = searchText
        searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
 //       searchController.searchBar.text = searchText
        updateSearchResults(for: searchController)
        //photoCView.reloadData()
    }
 

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo: PhotoMO = photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell else {fatalError()}
        cell.photoImage.kf.setImage(with: URL(string: photo.photoURL ?? ""))
        cell.authorLabel.text = photo.author
     
    
        return cell
    }



    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }

    
    private func fetchData() {
        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            print(error)
        }
    }

}

extension PhotoCollectionViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String){
            
            
        }
    }
}

extension PhotoCollectionViewController: PhotoCustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let photo: PhotoMO = photos[indexPath.row]
        var numberOfColumns = 2
        var contentWidth: CGFloat {
            let collectionView = collectionView
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell
//        return (photoImage?.size.height)!
 //       return photos[indexPath.item].image.size.height
        print("1")
        return columnWidth/CGFloat(photos[indexPath.row].photoWidth/photos[indexPath.row].photoHeight)
       // print(columnWidth/CGFloat(photos[indexPath.row].photoWidth/photos[indexPath.row].photoHeight))
    }
}

//extension PhotoCollectionViewController: UISearchBarDelegate {
//    // MARK: - UISearchResultsUpdating Delegate
//    func searchBar(_ searchBar: UISearchBar,
//                   textDidChange searchText: String){
//
//    }
//}
