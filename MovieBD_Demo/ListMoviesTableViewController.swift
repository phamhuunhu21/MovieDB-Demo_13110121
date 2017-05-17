//
//  ListMoviesTableViewController.swift
//  MovieBD_Demo
//
//  Created by Cntt28 on 5/17/17.
//  Copyright © 2017 Cntt28. All rights reserved.
//

import UIKit

class ListMoviesTableViewController: UITableViewController {

    var allMovie = [Movie]()
    var movePath: String?
    var page: Int?
    var totalPages: Int?
    var movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getMovies()
    }
    
    func getMovies() {
        getMovies(page: 1)
    }
    
    func getMovies(page: Int?) {
        var queryParams = [URLQueryItem]()
        
        if let page = page {
            queryParams.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        let url = ApiClient.createUrl(queryParams: queryParams)!
        print(url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url), completionHandler: {
            data, response, error in
            
            self.onFetchMoviesComplete(data, response: response, error: error as NSError?)
        })
        task.resume()
    }
    
    // lay list movies
    fileprivate func onFetchMoviesComplete(_ data: Data?, response: URLResponse?, error: NSError?) {
        
        
            if let rawData = data {
                do {
                   
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                   
                    self.page = jsonResponse?["page"] as? Int
                    self.totalPages = jsonResponse?["total_pages"] as? Int
                    if let moviesJson = jsonResponse?["results"] as? [[String: AnyObject]] {
                        for movieJson in moviesJson {
                            self.allMovie.append(Movie(parsedJson: movieJson))
                        }
                        self.movies = allMovie
                    }
                    
                }
                catch let error as NSError {
                    print("\(error.localizedDescription)")
                }
            }
        
        

        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as!MovieTableViewCell
        
        let movie = movies[indexPath.row]
        
        cell.lblTitle.text = movie.title
        cell.lblReview.text = movie.overview
        
        let posterUrl: String = "http://image.tmdb.org/t/p/w185"+movie.posterPath!
        print(posterUrl)
        Downloader.downloadImage(url: URL(string: posterUrl)!, cell: cell)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailFilmVC = segue.destination as! DetailMoviesViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = movies[indexPath.row]
                detailFilmVC.filmId = movie.id!
            }
        }
    }
    
}

class Downloader {
    
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
    
    class func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    class func downloadImage(url: URL, cell: MovieTableViewCell) -> Void{
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                cell.imgAvatar.image = UIImage(data: data)
            }
        }
    }
}
