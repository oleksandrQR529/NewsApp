//
//  NetworkService.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import Foundation

typealias OnApiSuccess = (Articles) -> Void
typealias OnApiError = (String) -> Void

class NetworkService {
    static let instance = NetworkService()
    let filterTypes: [String] = ["Category", "Country", "Sources"]
    let topHeadlineUrl = "http://newsapi.org/v2/top-headlines?"
    let everythingUrl = "http://newsapi.org/v2/everything?"
    let sortBy = "sortBy=publishedAt&"
    let apiKey = "apiKey=8ab386290a454dae972bdacba64dd8ae"
    let requestEnd = "&"
    let categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    let countries: [String] = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]

    private(set) var data: Articles?
    
    let session = URLSession(configuration: .default)
    
    func getArticles(dataUrl urlString: String, onSuccess: @escaping OnApiSuccess, onError: @escaping OnApiError) {
        guard let url = URL(string: urlString) else {return}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            self.connectToURl(error: error, response: response, data: data) { (articles) in
                onSuccess(articles)
                self.data = articles
            } onError: { (errorMessage) in
                onError(errorMessage)
            }
        }
        task.resume()
    }
    
    func connectToURl(error: Error?, response: URLResponse? , data: Data? , onSuccess: @escaping OnApiSuccess, onError: @escaping OnApiError) {
        
        DispatchQueue.main.async {
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data from response")
                return
            }
            
            do{
                if response.statusCode == 200 {
                    let items = try JSONDecoder().decode(Articles.self, from: data)
                    onSuccess(items)
                }else{
                    onError("Invalid data from response")
                }
            }catch{
                onError(error.localizedDescription)
            }
        }
    }
}
