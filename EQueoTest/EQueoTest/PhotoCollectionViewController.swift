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



class PhotoCollectionViewController: UICollectionViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate  {
    
    @IBOutlet var photoCView: UICollectionView!

    var searchController = UISearchController(searchResultsController: nil)

    
    public var photoImage: UIImage?
    
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
    
    public var photos: [PhotoMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
 
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedObjects = self.fetchResultsController?.fetchedObjects {
            photos = fetchedObjects
        }
        photoCView.reloadData()
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
        cell.authorLabel.text = "abuyz"//photo.author
     
    
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
        // TODO
    }
}
