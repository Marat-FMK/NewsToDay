//
//  DetailView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 20.10.2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    let news: News
    let action: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    Button(action: {
                        shareNewsText(news.description)
                    }) {
                        Image(systemName: "square.and.arrow.up.circle")
                            .foregroundStyle(.black)
                    }
                    .offset(x: 340, y: -200)
                    
                    news.image
                        .resizable()
                        .scaledToFill()
                        .opacity(0.5)
                        .frame(width: 375, height: 384)
                    
                    VStack(alignment: .leading) {
                        
                        Text(news.category)
                            .frame(width: 48, height: 16)
                            .font(.system(size: 12))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(Color.purple)
                            .clipShape(Capsule())
                        
                        Text(news.name)
                            .frame(width: 336, height: 56, alignment: .leading)
                            .lineLimit(2)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        
                        Text(news.author)
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                        
                        Text("Autor")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14))
                        
                    }
                    .padding(.leading, 8)
                    .offset(y: -30)
                }
                
                VStack {
                    Text("Results")
                        .font(.system(size: 16))
                        .bold()
                        .frame(width: 58, height: 24, alignment: .leading)
                        .padding(.top, 8)
                }
                
                ScrollView(showsIndicators: false) {
                    Text(news.description)
                        .frame(width: 336, alignment: .leading)
                        .padding(.top, 8)
                }
                
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 14, height: 14)
                            .padding(.leading, 12)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "bookmark")
                            .resizable()
                            .foregroundColor(news.bookmark ? .white : .gray)
                            .frame(width: 17, height: 24)
                            .padding(.trailing, 12)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    

    private func shareNewsText(_ text: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        rootVC.present(activityVC, animated: true, completion: nil)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(news: News(name: "Sample News", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Sample Author", description: "Sample description of the news article."), action: {})
    }
}
