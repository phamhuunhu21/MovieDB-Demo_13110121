//
//  Movie.swift
//  MovieBD_Demo
//
//  Created by Cntt28 on 5/17/17.
//  Copyright © 2017 Cntt28. All rights reserved.
//

import Foundation

class Movie {
    static let moviesPath = "/3/movie"
    static let nowPlayingPath = "/now_playing"
    
    
    var overview: String?
    var title: String?
    var posterPath: String?
    var voteAverage: Double?
    var id: Int?
    
    //du lieu
    init(parsedJson: [String: AnyObject]) {
        if let overview = parsedJson["overview"] as? String {
            self.overview = overview
        }
        
        if let posterPath = parsedJson["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let title = parsedJson["title"] as? String {
            self.title = title
        }
        
        if let voteAverage = parsedJson["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        
        if let id = parsedJson["id"] as? Int {
            self.id = id;
        }
    }
    
    
    
    class func getMovies(page: Int?, onComplete: @escaping (Data?, URLResponse?, NSError?) -> Void) {
        var queryParams = [URLQueryItem]()
        
        if let page = page {
            queryParams.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        let url = ApiClient.createUrl(queryParams: queryParams)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url), completionHandler: onComplete as! (Data?, URLResponse?, Error?) -> Void)
        task.resume()
    }
}
