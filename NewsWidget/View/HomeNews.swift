//
//  HomeNews.swift
//  NewsWidget
//
//  Created by MacBook J&J  on 18/07/22.
//

import SwiftUI

struct HomeNews: View {
    @StateObject var model = NewsViewModel()
    let urlImage = "https://img.freepik.com/vector-gratis/fondo-tecnologia-concepto-tierra-digital_1017-33684.jpg?w=1800&t=st=1658209520~exp=1658210120~hmac=f663a8c368496614865b3991c23c143730b3f2b72ad63bb5cc6eabccc68d892f"
    var body: some View {
        if model.newsData.articles.isEmpty {
            ProgressView()
        } else {
            GeometryReader { geo in
                List {
                    ForEach(model.newsData.articles, id: \.publishedAt) { item in
                        HStack {
                            Image(systemName: "person.fill")
                                .data(url: URL(string: item.urlToImage ?? urlImage)!)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .clipShape(Circle())
                            VStack {
                                Text(item.title)
                                    .frame(width: 250, height: 50, alignment: .leading)
                                    .font(.title3)
                                    .multilineTextAlignment(.leading)
                                Text(item.publishedAt)
                                    .frame(width: 250, height: 20, alignment: .leading)
                            }
                        }
                    }
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .edgesIgnoringSafeArea(.horizontal)
            }
        }

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
