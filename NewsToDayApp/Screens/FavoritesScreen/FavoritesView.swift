//
//  FavoritesView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct TitleHeaderView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Заголовок
            Text(title)
                .font(.custom("Inter", size: 24)) // Шрифт Inter, размер 24
                .fontWeight(.semibold) // Вес шрифта 600
                .foregroundColor(Color(.black)) // Используем кастомный цвет
                .lineSpacing(32 - 24) // Высота строки 32px
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: 28, leading: .zero, bottom: 8, trailing: .zero))
            
            // Подзаголовок
            Text(subtitle)
                .font(.custom("Inter", size: 16)) // Шрифт Inter, размер 16
                .fontWeight(.regular) // Вес шрифта 400
                .foregroundColor(Color(.gray)) // Используем кастомный цвет
                .lineSpacing(24 - 16) // Высота строки 24px
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
        }
    }
}

struct BookmarkView: View {
    // для примера
    @State private var bookmarks: [News] = [
        News(name: "News1", bookmark: false, image: Image("chinatown"), category: "Sport1", author: "Petka Popov1", description: "aboutNews1"),
        News(name: "det new", bookmark: false, image: Image("handLuggage"), category: "Politics", author: "Det Autor", description: "Det Descrdnvnjkdnvjndskjn kjn  nwekjnvkwnvkjnwk n nw kvnwn vwn vln lwnelvw nelvjnserkjvnsevnkjsen  njsne   eajnclane nake nckaneclancl"),
        News(name: "News2", bookmark: false, image: Image("timesquare"), category: "SportType2", author: "Petka Popov2", description: "aboutNews2"),
        News(name: "News3", bookmark: false, image: Image("chinatown"), category: "Sport3", author: "Petka Popov3", description: "aboutNews3")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                TitleHeaderView(title: "Bookmarks", subtitle: "Saved articles to the library" )
                    .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
                
                if bookmarks.isEmpty {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 72, height: 72)
                            
                            Image("book-alt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                        
                        Text("No bookmarks yet!")
                            .font(.system(size: 16, weight: .medium))
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                    .padding(.vertical, 150)
                } else {
                    List {
                        ForEach(bookmarks, id: \.id) { item in
                            ZStack {
                                ArticleView(model: item)
                                NavigationLink(
                                    destination: DetailView(news: item),
                                    label: {
                                        EmptyView() // Используем EmptyView для скрытия NavigationLink, чтобы не отображать отдельный элемент интерфейса.
                                    }
                                ).opacity(0) // Делаем NavigationLink невидимым, но он все равно будет активным для навигации при нажатии на статью
                            }
                            .listRowInsets(.init())
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 10)
                            .swipeActions {
                                Button(
                                    action: {
                                        // Удаление статьи
                                        if let index = bookmarks.firstIndex(where: { $0.id == item.id }) {
                                            bookmarks.remove(at: index)
                                        }
                                    },
                                    label:  {
                                        Text("Delete")
                                    }
                                )
                                .tint(.red)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct ArticleView: View {
    
    let model: News
       
       var body: some View {
           HStack() {
               // Используем встроенное изображение
               model.image
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   .frame(width: 96, height: 96)
                   .background(Color.black.opacity(0.4)) // Захардкоженный цвет фона
                   .clipShape(RoundedRectangle(cornerRadius: 12)) // Закругляем углы
               
               VStack(alignment: .leading) {
                   Text(model.name)
                       .font(.custom("Inter", size: 14)) // Шрифт Inter, размер 14
                       .fontWeight(.semibold) // Вес шрифта 600
                       .foregroundColor(Color(.black)) // Используем кастомный цвет
                       .lineSpacing(20 - 14)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.vertical, 8)
//                       .background(Color.yellow.opacity(0.1))

                   
                   Text(model.category)
                       .font(.system(size: 16, weight: .semibold))
                       .foregroundColor(Color(.black)) // Используем кастомный цвет
                       .lineSpacing(24 - 16)
                       .frame(height: 50, alignment: .top)
                       .padding(.bottom, 8)
                       .lineLimit(2)
//                       .background(Color.red.opacity(0.1))
        
               }
               .frame(maxWidth: .infinity)
               .padding(.init(top: .zero, leading: 16, bottom: .zero, trailing: .zero)) // Захардкоженные отступы для VStack
           }
       }
}
