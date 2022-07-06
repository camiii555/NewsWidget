//
//  ContentView.swift
//  NewsWidget
//
//  Created by MacBook J&J  on 6/07/22.
//

import SwiftUI

struct ContentView: View {
    let actuallyDate = Date()
    @StateObject var newsModel = NewsViewModel()
    var body: some View {
        Text("\(actuallyDate)").onAppear(){
            newsModel.loadResultNews()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
