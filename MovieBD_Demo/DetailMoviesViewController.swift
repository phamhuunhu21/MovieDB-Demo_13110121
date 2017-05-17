//
//  DetailMoviesViewController.swift
//  MovieBD_Demo
//
//  Created by Cntt28 on 5/17/17.
//  Copyright © 2017 Cntt28. All rights reserved.
//

import UIKit

class DetailMoviesViewController: UIViewController {

    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblReview: UITextView!
    
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    
    var filmId: Int = 0
    var movie: Movie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let url = ApiClient.getDetailFilm(filmId: filmId)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url!), completionHandler: {
            data, response, error in
            
            self.onFetchMovieDetailComplete(data, response: response, error: error as NSError?)
        })
        task.resume()
    }
    
    fileprivate func onFetchMovieDetailComplete(_ data: Data?, response: URLResponse?, error: NSError?) {
        
        
            if let rawData = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawData, options: [])
                    movie = Movie(parsedJson: jsonResponse as! [String : AnyObject])
                    DispatchQueue.main.async {
                        self.lblTitle.text = self.movie.title
                        self.lblReview.text = self.movie.overview
                        let posterUrl: String = "https://image.tmdb.org/t/p/w780"+self.movie.posterPath!
                        self.downloadImage(url: URL(string: posterUrl)!)
                    }
                    
                }
                catch let error as NSError {
                    // Handle JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) -> Void{
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.imgAvatar.image = UIImage(data: data)
            }
        }
    }
}
