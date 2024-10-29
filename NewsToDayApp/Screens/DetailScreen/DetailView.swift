//
//  DetailView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 20.10.2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let id: String
    let title: String
    let link: String?
    let creator: [String]?
    let description: String?
    let category: [String]?
    let isFavorite: Bool
    let imageUrl: String?
    
    let action: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomLeading) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.black)
                        
                        AsyncCachedImage(
                            url: URL(string: imageUrl ?? ""),
                            placeholder: Image(systemName: "photo")
                        )
                        .opacity(0.75)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(width: 405, height: 380)
                    
                    Button(action: {
                        shareNewsText(title)
                    }) {
                        Image(systemName: "arrowshape.turn.up.right")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                            
                    }
                    .offset(x: 355, y: -240)
                    
                    Link(destination: URL(string: link ?? "https://ria.ru/20241023/briks-1979545138.html")!) {
                        Image(systemName: "globe")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 25, height: 25)
                    }
                    .offset(x: 355, y: -190 )
                    
                    VStack(alignment: .leading) {
                        
                        Text(category?.first ?? Resources.Text.noCategory)
                            .font(.interRegular(12))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(DS.Colors.purplePrimary)
                            .clipShape(Capsule())
                            .padding(.bottom,10)
                        
                        Text(title)
                            .frame(width: 336, height: 56, alignment: .leading)
                            .lineLimit(2)
                            .font(.interSemiBold(20))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        
                        Text(creator?.first ?? Resources.Text.noAuthor)
                            .font(.interSemiBold(16))
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                        
                        Text(Resources.Text.author)
                            .foregroundColor(.white)
                            .font(.interMedium(14))
                        
                    }
                    .padding(.leading, 26)
                    .offset(y: -30)
                }
                
                VStack(alignment: .leading) {
                
                    Text(Resources.Text.resaults)
                            .font(.interSemiBold(16))
                            .frame(width: 58, height: 24, alignment: .leading)
                            .padding(.top,24)
                      
                    ScrollView(showsIndicators: false) {
                        Text(description ?? "")
                            .font(.interMedium(16))
                            .foregroundStyle(DS.Colors.grayDark)
                            .frame(width: 336, alignment: .leading)
                            .padding(.top, 8)
                    }
                }
                    .padding()
                
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
                            .foregroundColor(isFavorite ? .white : .gray)
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


//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
////        DetailView(news: News(name: "Sample News", bookmark: true, image: Image("handLuggage"), category: "Politics", author: "Sample Author", description: "Leads in individual states may change from one party to another as all the votes are counted. Select a state for detailed results, and select the Senate, House or Governor tabs to view those races.\n\n For more detailed state results click on the States A-Z links at the bottom of this page. Results source: NEP/Edison via Reuters.\n\n Leads in individual states may change from one party to another as all the votes are counted. Select a state for detailed results, and select the Senate, House or Governor tabs to view those races.\n\n For more detailed state results click on the States A-Z links at the bottom of this page. Results source: NEP/Edison via Reuters."), action: {})
//    }
//}
