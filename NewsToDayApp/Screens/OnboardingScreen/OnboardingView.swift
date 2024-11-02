//
//  OnboardingView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 21.10.2024.
//

import SwiftUI


struct Item: Identifiable { // in Model File
    var id = UUID()
    let image: Image
    let title: String
    let discription: String
}

struct PageNumber: View {
    let number: Int
    var body: some View {
        
        if number == 0 {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(DS.Colors.purplePrimary)
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
            }
        }
        if number == 1 {
            HStack {
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(DS.Colors.purplePrimary)
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
            }
        }
        if number == 2 {
            HStack {
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
                Circle()
                    .foregroundStyle(DS.Colors.grayLighter)
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(DS.Colors.purplePrimary)
            }
        }
        
    }
}

struct OnboardingView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @StateObject var viewModel: OnboardingViewModel
    
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    init(router: StartRouter) {
        self._viewModel = StateObject(wrappedValue: OnboardingViewModel(router: router))
    }
    
    let numberOfItems = 3
    let itemWidth: CGFloat = 300
    private let peekAmount:CGFloat = -10
    private let dragThreshhold: CGFloat = 100
    
    let items: [Item] = [Item(image: Image("chinatown"), title: "First to know", discription: "All news is one place, be the first to know last news"), Item(image: Image("handLuggage"), title: "Second to know ;)", discription: "Choose the right category and watch what you like!"), Item(image: Image("timesquare"), title: "Third and go...", discription: "Search for the news you are interested in using the search bar.")]
    
    
    let itemsRus = ["Все новости в одном месте, будьте первыми, кто узнает последние новости.", "Выберите нужную категорию и смотри то, что тебе нравится !", "Ищите интересующие вас новости через поисковую строку."]
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack {
                ForEach(items.indices, id: \.self) { index in
                    
                    items[index].image
                        .resizable()
                        .frame(width: 288, height: 336)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .center) {
                            
//                            PageNumber(number: index)
//                                .frame(width: 56, height: 8)
//                                .offset(y:190)
                            
                            // // //
                            
                            // принять только перевод и все что с ним связано
                            
                            // // //
                            
                            Text( language == .en ?  items[index].title : itemsRus[index])
                                .font(.interSemiBold(24))
                                .offset(y:220)
                            
                            Text( language == .en ? items[index].discription : itemsRus[index])
                                .frame(width: 216, height: 68, alignment:.center)
                                .font(.interRegular(18))
                                .foregroundStyle(DS.Colors.grayPrimary)
                                .offset(y: 290)
                            
                            
                            if index == 2 {
                                Button(action: viewModel.onboardingCompleted) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(width: 220, height: 56)
                                        .foregroundStyle(Color.purple)
                                    Text("Get Started")
                                        .font(.interSemiBold(16))
                                        .foregroundStyle(Color.white)
                                }
                            }
                                .offset(y: 480)
                            }
                        }
                        .scaleEffect(self.scaleValueForItem(at: index, in: geometry))
                }
            }
            .offset(x: calculeteOffset() + dragOffset + 50)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        withAnimation(.interactiveSpring()){
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        withAnimation(.interactiveSpring()) {
                            
                            finalizePosition(dragValue: value)
                            dragOffset = 0
                           
                        }
                    }
            )
        }

        .offset(y:100)
        
    }
    func calculeteOffset() -> CGFloat {
        let totalItemWidth = itemWidth + peekAmount
        let baseOffset = -CGFloat(currentIndex) * totalItemWidth
        
        return baseOffset
    }
    
    func scaleValueForItem(at index: Int, in geometry: GeometryProxy) -> CGFloat {
        
        let currentItemOffset = calculeteOffset() + dragOffset
        let itemPosition = CGFloat(index) * (itemWidth + peekAmount) + currentItemOffset
        let distanceFromCenter = abs(geometry.size.width / 2 - itemPosition - itemWidth / 2)
        let scale: CGFloat = 0.8 + (0.2 * (1 - min(1, distanceFromCenter / (itemWidth + peekAmount))))
        
        return scale
    }
    
    private func finalizePosition(dragValue: DragGesture.Value) {
        if dragValue.predictedEndTranslation.width > dragThreshhold && currentIndex > 0 {
            currentIndex -= 1
        } else if dragValue.predictedEndTranslation.width < -dragThreshhold && currentIndex < numberOfItems - 1 {
            currentIndex += 1
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(router: StartRouter())
    }
}
