//
//  ViewController.swift
//  Flix
//
//  Created by Donnie on 2/11/22.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Array of dictionary
    var movies = [[String: Any]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        
        let summary = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.summaryLabel.text = summary
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        cell.posterImage.af.setImage(withURL: posterUrl)
        
        return cell
    }
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // API to Get Movie Data
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 //Storing the array of movies
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                // Reloads the Data
                 self.tableView.reloadData()
             }
        }
        task.resume()
        
    }
}

