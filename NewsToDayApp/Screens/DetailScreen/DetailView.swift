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
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                ZStack(alignment: .bottomLeading) {
                    
                    ShareLink(item: news.description) { // передает текст новости / можно в модель добавить ЮРЛ  и отдавать ее
                        Label("", systemImage: "square.and.arrow.up.circle") // Image?
                    }
                    .foregroundStyle(Color.black) // white !! не отображается белая почеу то , все остальное работает
                    .offset(x: 340, y: -200)
                    
                    news.image
                        .resizable()
                        .scaledToFill()
                        .opacity(0.5) // удалить на релизн версии
                        .frame(width: 375, height: 384 )
                    
                    VStack(alignment: .leading) {
                        
                        Text(news.type)
                            .frame(width: 48, height: 16)
                            .font(.system(size: 12))
                            .padding(.horizontal,16)
                            .padding(.vertical,8)
                            .foregroundStyle(.white)
                            .background(.purple) // 71 90 215
                            .clipShape(.capsule)
                        
                        Text(news.news)
                            .frame(width: 336, height: 56, alignment: .leading)
                            .lineLimit(2)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(.bottom,30)
                        
                        
                        Text(news.author)
                            .font(.system(size: 16))
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.bottom,8)
                        
                        Text("Autor")
                            .foregroundStyle(Color.white) // 172 175 195
                            .font(.custom("Helvetica Neue", size: 14))
                        
                    }
                    .padding(.leading,8)
                    .offset(y: -30)
                    
                }
                
                VStack {
                    Text("Results")
                        .font(.system(size: 16))
                        .bold()
                        .frame(width: 58, height: 24, alignment: .leading)
                        .padding(.top,8)
                }
                
                ScrollView(showsIndicators: false) {
                    Text(news.description)
                        .frame(width: 336, alignment: .leading)
                    
                        .padding(.top,8)
                }
                
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss() // close
                    } label: {
                        Image(systemName: "arrow.left") //image!
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 14, height: 14)
                            .padding(.leading,12)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // bookmark choose add/delete
                    } label: {
                        Image(systemName: "bookmark") //image!
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 17, height: 24)
                            .padding(.trailing,12)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
        
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(news: News(news: "det new", annotation: "detAnot", image: Image("handLuggage"), type: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpwet Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw"))
    }
}

