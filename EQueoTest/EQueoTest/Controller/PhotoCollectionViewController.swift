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
    
    @IBOutlet var photoCollectionView: UICollectionView!

    public var photos: [PhotoMO] = []
    public var photoImage: UIImage?
    
    // MARK: - NSFetchedResultsController
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let layout = collectionView?.collectionViewLayout as? PhotoCustomLayout {
            layout.delegate = self
        }
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            photos = fetchedObjects
        }
        
        photoCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        
        if let layout = collectionView?.collectionViewLayout as? PhotoCustomLayout {
            layout.delegate = self
        }
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
        
        PhotoService.shared.getPhotos(searchText: nil)
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let layout = collectionView?.collectionViewLayout as? PhotoCustomLayout {
            layout.delegate = self
        }
        updateSearchResults(for: searchController)
    }
    
    // Mark: - SearchBar
    var searchController = UISearchController(searchResultsController: nil)

    public func searchBar(_ searchBar: UISearchBar,
                          textDidChange searchText: String){
        PhotoService.shared.getPhotos(searchText: searchText)
        photoCollectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    private func fetchData() {
        do {
            try self.fetchResultsController?.performFetch()
            if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
                photos = fetchedObjects
            }
            photoCollectionView.reloadData()
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
        print(columnWidth)
        let height = columnWidth/CGFloat(photos[indexPath.row].photoWidth/photos[indexPath.row].photoHeight)
        print(height)
        print(photos[indexPath.row].photoWidth)
        print(photos[indexPath.row].photoHeight)
        return height
    }
}
