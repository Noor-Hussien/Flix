//
//  MoviesViewController.swift
//  Flix
//
//  Created by Noor Ali on 9/29/20.
//

import UIKit
import AlamofireImage // special library

class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    // An array of dictionaries, with String-> Any Value
    var movies = [[String:Any]]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
            self.tableView.reloadData() // populate the table view by calling tableView stubs

              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    // This Function asks for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return movies.count
        return movies.count
    }
    // for this particluar row give me the cell, it is called movies.count times
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as!
        MovieCell   // create new cell
        // ? and ! are swift optionals
        let movie = movies[indexPath.row] // accessing the movie array by index
        let title = movie["title"] as! String // accessing dictionary using key and cast to string
        let synopsis = movie["overview"] as! String // get synopsis
        cell.titleLabel!.text = title
        cell.synopsisLabel.text = synopsis
        
        let posterPath = movie["poster_path"] as! String // it was backdrop_path before 
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl +
                                posterPath)
        
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        // find the selected movie
        let cell = sender as! UITableViewCell // the being tapped on
        let indexPath = tableView.indexPath(for: cell)! // the index of that cell
        
        let movie = movies[indexPath.row]  // access the array movie
        
        // pass the selected movie to the details View controller
        // The reason it is casted is because it gives a generic UIViewController and we want MovieController
        let detailsviewController = segue.destination as!
            MovieDetailsViewController
        detailsviewController.movie = movie // refers to the let movie
        
        tableView.deselectRow(at: indexPath, animated: true) // cell not selected anymore

    }


}
