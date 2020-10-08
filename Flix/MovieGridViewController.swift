//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Noor Ali on 10/7/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!

    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
        layout.minimumLineSpacing = 40 // space in between rows
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width  -  layout.minimumInteritemSpacing * 2) / 3 // three posters
        layout.itemSize = CGSize(width: width, height:width*3 / 2) // heigh is 1.5 tall
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              //print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try!
                JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
           
            // TODO: Get the array of movies
            /*
             To assign value to movies
                1.you need closure, self.movie
                2. Type casting dataDictionary["results"] as! [[String:Any]]
             */
            self.movies = dataDictionary["results"] as! [[String:Any]]
            //self.tableView.reloadData() // populate the table view by calling tableView stubs

              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
            self.collectionView.reloadData() // cause 
            print(self.movies)

           }
        }
        task.resume()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let posterPath = movie["poster_path"] as! String // it was backdrop_path before
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterUrl = URL(string: baseUrl +
                                posterPath)
        
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
