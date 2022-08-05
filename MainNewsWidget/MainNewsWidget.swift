//
//  MainNewsWidget.swift
//  MainNewsWidget
//
//  Created by MacBook J&J  on 6/07/22.
//

import WidgetKit
import SwiftUI

// Modelo

struct ModelWidget: TimelineEntry {
    var date: Date
    var articles: [Article]
}

// Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ModelWidget {
        return ModelWidget(date: Date(), articles: Array(repeating: Article(author: "", title: "", urlToImage: "", publishedAt: ""), count: 1))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ModelWidget) -> Void) {
        completion(ModelWidget(date: Date(), articles: Array(repeating: Article(author: "", title: "", urlToImage: "", publishedAt: ""), count: 1)))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ModelWidget>) -> Void) {
        getNewsApple { article in
            let data = ModelWidget(date: Date(), articles: article)
            guard let update = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) else { return }
            let timeline = Timeline(entries: [data], policy: .after(update))
            completion(timeline)
        }
        
    }
    
    typealias Entry = ModelWidget

}

func getNewsApple(completion: @escaping ([Article]) -> ()) {
    let ActuallyDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
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
            let json = try JSONDecoder().decode(NewsModel.self, from: data)
            DispatchQueue.main.async {
                completion(json.articles)
            }
            
        } catch let error as NSError {
            print("Error, \(error.localizedDescription)")
        }

        
    }.resume()
}

// Vista

struct NewsView: View {
    let entry: Provider.Entry
    let urlImage = "https://img.freepik.com/vector-gratis/fondo-tecnologia-concepto-tierra-digital_1017-33684.jpg?w=1800&t=st=1658209520~exp=1658210120~hmac=f663a8c368496614865b3991c23c143730b3f2b72ad63bb5cc6eabccc68d892f"
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        if entry.articles.isEmpty {
            ProgressView()
        } else {
            switch family {
            case .systemSmall:
                ZStack {
                    Image(systemName: "person.fill")
                        .data(url: URL(string: entry.articles.first?.urlToImage ?? urlImage)!)
                        .scaledToFill()
                    VStack {
                        Text(entry.articles.first?.title ?? "")
                            .foregroundColor(.white)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .frame(width: 150, height: 150, alignment: .center)
                    }
                }
            case .systemMedium:
                ZStack {
                    Image(systemName: "person.fill")
                        .data(url: URL(string: entry.articles.first?.urlToImage ?? urlImage)!)
                        .scaledToFill()
                    VStack{
                        Text(entry.articles.first?.title ?? "")
                            .padding()
                            .foregroundColor(.white)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                        Text(entry.articles.first?.publishedAt ?? "")
                            .foregroundColor(.white)
                            .font(.body)
                            .frame(maxWidth: 330, maxHeight: 20, alignment: .leading)
                    }
                }
            default:
                ZStack {
                    Image(systemName: "person.fill")
                        .data(url: URL(string: entry.articles.first?.urlToImage ?? urlImage)!)
                        .scaledToFill()
                    VStack{
                        Text(entry.articles.first?.title ?? "")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                    }
                }

            }
        }
    }
}


// Configuracion
@main
struct NewsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "widget", provider: Provider()) { TimelineEntry in
            NewsView(entry: TimelineEntry)
        }.description("descripcion del widget")
            .configurationDisplayName("News")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url){
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self.resizable()
    }
}








