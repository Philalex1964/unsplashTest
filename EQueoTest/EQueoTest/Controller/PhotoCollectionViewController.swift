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
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            photos = fetchedObjects
        }
        photoCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()

        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        searchController.searchBar.placeholder = "Search"
        self.definesPresentationContext = true
        
        PhotoService.shared.getPhotos(searchText: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearchResults(for: searchController)
    }
    
    // MARK: - SearchBar
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
