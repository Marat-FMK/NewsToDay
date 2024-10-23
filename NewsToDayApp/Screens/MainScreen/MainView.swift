//
//  MainView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    
    @State private var selectedTitleForSort = 0
    @State private var searchText = ""
    @State private var selectedCategory = "Random"
    
    // @State private var categoryNews: [News] = [] // новости по выбранной категории
    // @State private var recommendedNews: [News] = [] // рекомендованные в верт стеке
    
    @State private var categoryNews: [News] = [ // пример
        News(name: "News: Russian benzin exceeded 60 rub !!!", bookmark: true, image: Image("chinatown"), category: "Politic", author: "Petka Popov1", description: "aboutNews1"), News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpwet Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw"),
        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"), News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")]
    
    @State private var recommendedNews: [News] = [ // пример
        News(name: "A Simple Trick For Creating", bookmark: true, image: Image("chinatown"), category: "UI/UX Design", author: "Petka Popov1", description: "A Simple Trick For Creating"), News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw et Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpwet Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl nalalenlnacnwepvjowpqvjqvnowpnv ncpwepvnpw"),
        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"), News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")]
    
    let categories = ["Random", "Sports", "Gaming", "Politics", "Life", "Animals", "Nature", "Food", "Art", "History", "Fashion", "Covid-19", "Middle East"]
    
    let sortTitles = [ "All", "Bookmark", "A - z"]
    var body: some View {
        
                    
                    VStack {
                        CustomToolBar(
                            title: Resources.Text.mainTitle,
                            subTitle: Resources.Text.mainSubTitle
                        )
                        .padding(.top, 0)
                        
                        ScrollView(showsIndicators: false) {
                        
                        VStack(alignment: .leading) {

                            SearchBar(text: $viewModel.searchText)
                                .padding(.bottom, 16)
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
                                    ForEach(viewModel.getTopNews()) { news in
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
                            
                            
                            ForEach(viewModel.getTopNews()) { news in
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
                .task {
                    await viewModel.fetchTopNews()
                }
                .ignoresSafeArea()

    }
    
    private func checkSelectedCategory(_ categoryName: String)-> Bool {
        selectedCategory == categoryName ? true : false
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(viewModel: MainViewModel(newsAPIManager: NewsAPIManager()))
        }
    }
}
