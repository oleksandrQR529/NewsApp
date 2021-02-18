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
