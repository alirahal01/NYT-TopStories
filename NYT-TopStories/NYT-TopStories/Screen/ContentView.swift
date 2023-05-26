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
        
        List {
            ForEach(viewModel.articles.indices, id: \.self) { index in
                let article = viewModel.articles[index]
                HStack {
                    if let imageURL = article.multimedia?[2].url, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            // Placeholder image or loading indicator
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(article.title ?? "")
                            .font(.subheadline)
                        
                        Spacer()
                        Text(article.publishedDate ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
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
