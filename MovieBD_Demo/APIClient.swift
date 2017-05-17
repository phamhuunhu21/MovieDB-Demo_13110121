//
//  ApiClient.swift
//  MovieBD_Demo
//
//  Created by Cntt28 on 5/17/17.
//  Copyright © 2017 Cntt28. All rights reserved.
//

import Foundation

class ApiClient {
    static let scheme = "https"
    static let host = "api.themoviedb.org"
    static let apiKeyParam = "api_key"
    static var apiKey: String = "e88981f976a7598b1e56811e6de7b4ee"
    
    
    static let nowPlayingPath = "/now_playing"
    
    
    class func createUrl(queryParams: [URLQueryItem]?) -> URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = "/3/movie"+nowPlayingPath
        urlComponent.queryItems = [apiKeyQueryParam()]
        
        
        if let queryParams = queryParams {
            urlComponent.queryItems?.append(contentsOf: queryParams)
        }
        return urlComponent.url
    }
    
    
    
    class func apiKeyQueryParam() -> URLQueryItem {
        return URLQueryItem(name: apiKeyParam, value: apiKey)
    }
    
  //Chi tiet movie
    class func getDetailFilm(filmId: Int) -> URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = "/3/movie/"+String(filmId)
        urlComponent.queryItems = [apiKeyQueryParam()]
        
        return urlComponent.url
    }
}
