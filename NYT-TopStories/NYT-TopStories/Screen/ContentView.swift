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
        let state = viewModel.state
        
        switch state {
        case . idle:
            Color.clear.onAppear(perform: viewModel.LoadData)
        case .loading:
            ProgressView()
                .imageScale(.large)
        case .success(let loadingViewModel):
            List {
                ForEach(loadingViewModel.articlesData.indices, id: \.self) { index in
                    let article = loadingViewModel.articlesData[index]
                    HStack {
                        if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                            } placeholder: {
                                // Placeholder image or loading indicator
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "􀏅")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(article.title ?? "")
                                .font(.subheadline)
                            
                            Spacer()
                            Text(article.publishedDate ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(5)
                    }
                    .listRowSeparator(.hidden)

                }
                
            }
        case .failed(let errorViewModel):
            Color.clear.alert(isPresented: $viewModel.showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorViewModel.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
