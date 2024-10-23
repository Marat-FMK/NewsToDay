//
//  MainView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI

struct News: Identifiable { // in Model File
    var id = UUID()
    var name: String // название
    var bookmark: Bool
    var image: Image
    var category: String
    var author: String
    var description: String
}

struct CategoryNewsView: View {
    
    let news: News
    
    var body: some View {
        ZStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.black)
                news.image
                    .resizable()
                    .opacity(0.75)
                    .frame(width: 256, height: 256)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                // Add bookmark and save news on savedNews
            }
            label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 18, height: 24)
                    .foregroundStyle(news.bookmark ? .white : DS.Colors.grayLight)
            }
            .offset(x: 90, y: -90)
            
            VStack(alignment: .leading ) {
                Text(news.category.uppercased())
                    .font(.interRegular(16))
                    .foregroundStyle(DS.Colors.grayLighter)
                Text(news.name)
                    .font(.interSemiBold(16))
                    .frame(width: 208, height: 48, alignment: .leading)
                    .lineLimit(2)
                    .foregroundStyle(Color.white)
                    .offset(y: -10)
                
            }
            .padding(.top,160)
        }
    }
}

struct RecommendedNewsView: View {
    let news: News
    
    var body: some View {
        HStack {
            
            ZStack {
                
//                RoundedRectangle(cornerRadius: 12) // Раскоментить , если надо затемнить рекоменд тоже
//                    .foregroundStyle(.black)
//                    .frame(width: 96, height: 96)
                news.image
                    .resizable()
//                    .opacity(0.75)
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            VStack(alignment: .leading) {
                Text(news.category)
                    .frame(width:224, height: 20, alignment: .leading)
                    .font(.interMedium(14))
                    .foregroundStyle(DS.Colors.grayPrimary)
                
                Text(news.name)
                    .frame(width: 223, height: 48, alignment: .leading)
                    .font(.interSemiBold(16))
                    .foregroundStyle(DS.Colors.blackyPrimary)
                    .lineLimit(2)
            }
            .padding(.leading,16)
        }
    }
}

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    @State private var searchText = ""
    @State private var selectedCategory = "Random"
    
    // @State private var categoryNews: [News] = [] // новости по выбранной категории
    // @State private var recommendedNews: [News] = [] // рекомендованные в верт стеке
    
    @State private var categoryNews: [News] = [ // пример
        News(name: "News: Russian benzin exceeded 60 rub !!!", bookmark: true, image: Image("chinatown"), category: "Sport1", author: "Petka Popov1", description: "aboutNews1"), News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpwet Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw"),
        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"), News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")]
    
    @State private var recommendedNews: [News] = [ // пример
        News(name: "News: Russian benzin exceeded 60 rub !!!", bookmark: true, image: Image("chinatown"), category: "Sport1", author: "Petka Popov1", description: "aboutNews1"), News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpwet Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw"),
        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"), News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")]
    
    let categories = ["Random", "Sports", "Gaming", "Politics", "Life", "Animals", "Nature", "Food", "Art", "History", "Fashion", "Covid-19", "Middle East"]
    
    var body: some View {
        
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Discover things of this world") // add in NavStack
                                .frame(width:216, height:  24)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(Color.gray)
                                TextField(" Search ", text: $searchText)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 336, height: 56)
                            }
                            .padding(.bottom,20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(categories, id: \.self) { categoryName in
                                        Button {
                                            selectedCategory = categoryName
                                        }
                                        label: {
                                            Text(categoryName)
                                                .font(.system(size: 12))
                                                .padding(.horizontal,16)
                                                .padding(.vertical,8)
                                                .foregroundStyle(checkSelectedCategory(categoryName) ? .white : DS.Colors.grayPrimary)
                                                .background(checkSelectedCategory(categoryName) ? DS.Colors.purplePrimary : DS.Colors.grayLighter)
                                                .clipShape(Capsule())
                                                .padding(.horizontal,5)
                                        }
                                    }
                                }
                                .padding(.bottom,20)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(categoryNews) { news in
                                        NavigationLink {
                                            DetailView(news: news, action: {})
                                        } label: {
                                            CategoryNewsView(news: news)
                                        }
                                    }
                                }
                            }
                            
                            .padding(.bottom,50)
                            
                            HStack {
                                Text("Recommended for you")
                                    .font(.interSemiBold(20))
                                    .frame(width: 240, height: 24)
                                    .foregroundStyle(DS.Colors.blackyPrimary)
                                
                                Spacer()
                                
                                Button {
                                    //seeAll func button
                                }label: {
                                    Text("See All")
                                        .font(.interRegular(14))
                                        .foregroundStyle(DS.Colors.grayPrimary)
                                }
                            }
                            .padding(.bottom,30)
                            
                            
                            ForEach(recommendedNews) { news in
                                NavigationLink {
                                    DetailView(news: news, action: {})
                                } label: {
                                    RecommendedNewsView(news: news)
                                        
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Browse")
                //            .searchable(text: $searchText, prompt: "Search")
         
    }
    
    private func checkSelectedCategory(_ categoryName: String)-> Bool {
        selectedCategory == categoryName ? true : false
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
        
    }
}
