//
//  ContentView.swift
//  NYT-TopStories
//
//  Created by ali rahal on 26/05/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ArticlesViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            List {
                ForEach(viewModel.articles.indices, id: \.self) { index in
                    let article = viewModel.articles[index]
                    VStack(alignment: .leading,spacing: 12) {
                        Text(article.title!)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.LoadData()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
