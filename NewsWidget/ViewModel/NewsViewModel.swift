//
//  NewsViewModel.swift
//  NewsWidget
//
//  Created by MacBook J&J  on 6/07/22.
//

import Foundation

class NewsViewModel: ObservableObject {
    
    init() {
        loadResultNews()
    }
    
    func loadResultNews() {
        let ActuallyDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let paramDate = dateFormatter.string(from: ActuallyDate)
        let apiKey = "34d304d29222407c82b886c4b5029ee5"
        
        let params = ["q": "apple", "from": paramDate, "to": paramDate, "sortBy": "popularity", "apiKey": apiKey]
        
        var components = URLComponents(string: "https://newsapi.org/v2/everything?")!
        components.queryItems = params.map { (key, values) in
            URLQueryItem(name: key, value: values)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            guard let data = data else {
                return
            }
            do {
                let json = try JSONDecoder().decode(News.self, from: data)
                DispatchQueue.main.async {
                    print(json)
                }
                
            } catch let error as NSError {
                print("Error, \(error.localizedDescription)")
            }

            
        }.resume()
    }
}
