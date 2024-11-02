//
//  DetailView.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 20.10.2024.
//

import SwiftUI



// MARK: - DetailView
struct DetailView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: DetailViewModel
    
    struct Drawing {
        // MARK: - Dimensions
        static let articleImageWidth: CGFloat = 405
        static let articleImageHeight: CGFloat = 380
        static let buttonSize: CGFloat = 24
        static let globeButtonSize: CGFloat = 25
        static let categoryFontSize: CGFloat = 12
        static let titleFontSize: CGFloat = 20
        static let authorFontSize: CGFloat = 16
        static let resultsFontSize: CGFloat = 16
        static let descriptionFontSize: CGFloat = 16

    }
    
    // MARK: - Initializer
    init(_ article: ArticleDTO) {
        self._viewModel = StateObject(
            wrappedValue: DetailViewModel(detailArticle: article)
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.black)
                    
                    AsyncCachedImage(url: URL(string: viewModel.detailArticle.imageUrl ?? ""))
                        .opacity(0.75)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(width: Drawing.articleImageWidth, height: Drawing.articleImageHeight)
                
                Button(action: {
                    shareNewsText(viewModel.detailArticle.title)
                }) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .resizable()
                        .frame(width: Drawing.buttonSize, height: Drawing.buttonSize)
                        .foregroundStyle(.white)
                }
                .offset(x: 355, y: -240)
                
                Link(destination:
                        URL(string:
                            viewModel.detailArticle.link
                            ?? "https://ria.ru/20241023/briks-1979545138.html")!
                ) {
                    Image(systemName: "globe")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: Drawing.globeButtonSize, height: Drawing.globeButtonSize)
                }
                .offset(x: 355, y: -190)
                
                VStack(alignment: .leading) {
                    Text(viewModel.detailArticle.category?.first?.localized(language) ?? Resources.Text.noCategoryMessage.localized(language))
                        .font(.interRegular(Drawing.categoryFontSize))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundStyle(.white)
                        .background(DS.Colors.purplePrimary)
                        .clipShape(Capsule())
                        .padding(.bottom, 10)
                    
                    Text(viewModel.detailArticle.title.localized(language))
                        .frame(width: 336, height: 56, alignment: .leading)
                        .lineLimit(2)
                        .font(.interSemiBold(Drawing.titleFontSize))
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    Text(viewModel.detailArticle.creator?.first?.localized(language) ?? Resources.Text.noAuthorMessage.localized(language))
                        .font(.interSemiBold(Drawing.authorFontSize))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                    
                    Text(Resources.Text.author.localized(language))
                        .foregroundColor(.white)
                        .font(.interMedium(14))
                }
                .padding(.leading, 26)
                .offset(y: -30)
            }
            
            VStack(alignment: .leading) {
                Text(Resources.Text.resultsMessage.localized(language))
                    .font(.interSemiBold(Drawing.resultsFontSize))
                    .frame(/*width: 58,*/ height: 24, alignment: .leading)
                    .padding(.top, 24)
                
                ScrollView(showsIndicators: false) {
                    Text(viewModel.detailArticle.description?.localized(language) ?? "")
                        .font(.interMedium(Drawing.descriptionFontSize))
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
                    viewModel.toggleBookmark()
                } label: {
                    Image(systemName: "bookmark")
                        .resizable()
                        .foregroundColor(
                            viewModel.isBookmarked
                            ? .red
                            : .gray
                        )
                        .frame(width: 17, height: 24)
                        .padding(.trailing, 12)
                }
            }
        }
        .background(Color.newsBackground)
        .navigationBarBackButtonHidden(true)
    }
    
    private func shareNewsText(_ text: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        rootVC.present(activityVC, animated: true, completion: nil)
    }
}

// struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(news: News(name: "Sample News", bookmark: true, image: Image("handLuggage"), category: "Politics", author: "Sample Author", description: "Leads in individual states may change from one party to another as all the votes are counted. Select a state for detailed results, and select the Senate, House or Governor tabs to view those races.\n\n For more detailed state results click on the States A-Z links at the bottom of this page. Results source: NEP/Edison via Reuters.\n\n Leads in individual states may change from one party to another as all the votes are counted. Select a state for detailed results, and select the Senate, House or Governor tabs to view those races.\n\n For more detailed state results click on the States A-Z links at the bottom of this page. Results source: NEP/Edison via Reuters."), action: {})
//    }
//}
