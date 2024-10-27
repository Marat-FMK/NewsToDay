////
////  FavoritesView.swift
////  NewsToDayApp
////
////  Created by Evgeniy on 20.10.2024.
////

import SwiftUI

struct BookmarkView: View {
//    // для примера
//    //    @State private var bookmarks: [News] = [
//    //        News(name: "News1", bookmark: false, image: Image("chinatown"), category: "Sport1", author: "Petka Popov1", description: "aboutNews1"),
//    //        News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl"),
//    //        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"),
//    //        News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")
//    //    ]
//    
//    private var bookmarks: [ArticleDTO] = []
//    
    var body: some View {
        VStack {
            CustomToolBar(
                title: Resources.Text.bookmarksTitile,
                subTitle: Resources.Text.bookmarksSubTitle
            )
            .padding(.top, 0)
//            
//            if bookmarks.isEmpty {
//                VStack {
//                    ZStack {
//                        Circle()
//                            .fill(Color.gray.opacity(0.3))
//                            .frame(width: 72, height: 72)
//                        
//                        Image("book-alt")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 24, height: 24)
//                    }
//                    .padding(.vertical, 150)
//                }
//                                } else {
//                                    List {
//                                        ForEach(bookmarks, id: \.id) { item in
//                                            ZStack {
//                                                ArticleView(model: item)
//                                                NavigationLink(
//                                                    destination:
//                                                        DetailView(
//                                                            title: item.title,
//                                                            isFavorite: item.isFavorite,
//                                                                   action: {})
//                                                ),
//                                                    label: {
//                                                        EmptyView() // Используем EmptyView для скрытия NavigationLink, чтобы не отображать отдельный элемент интерфейса.
//                                                    }
//                                                ).opacity(0) // Делаем NavigationLink невидимым, но он все равно будет активным для навигации при нажатии на статью
//            }
//                .listRowInsets(.init())
//                .listRowSeparator(.hidden)
//                .padding(.vertical, 10)
//                .swipeActions {
//                    Button(
//                        action: {
//                            // Удаление статьи
//                            //                                        if let index = bookmarks.firstIndex(where: { $0.id == item.id }) {
//                            //                                            self.bookmarks.remove(at: index)
//                            //                                        }
//                        },
//                        label:  {
//                            Text("Delete")
//                        }
//                    )
//                    .tint(.red)
//                }
//        }
//    }
//}
//    .listStyle(.plain)
//    .padding(.horizontal, 20)
//}
}
    .navigationBarHidden(true)
    .background(.background)
    .ignoresSafeArea()
}
}

