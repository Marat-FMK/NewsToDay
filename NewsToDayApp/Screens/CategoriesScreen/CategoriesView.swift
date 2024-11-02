//
//  CategoriesView.swift
//  NewsToDayApp
//
//  Created by Evgeniy on 20.10.2024.
//

import SwiftUI

struct CategoriesView: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    
    @StateObject private var viewModel: CategoriesViewModel
    
    @State var mode: Mode = .screen
    
    enum Mode {
        case onboarding
        case screen
    }
    
    // MARK: - Drawing Constants
    enum Drawing {
        static let columnsSpacing: CGFloat = 12
        static let columnsCount = 2
        static let cornerRadius: CGFloat = 8
        static let horizontalSpacing: CGFloat = 8
        static let verticalSpacing: CGFloat = 20
    }
    
    // MARK: - Initializer
    init(mode: Mode, router: StartRouter) {
        self.mode = mode
        self._viewModel = StateObject(
            wrappedValue: CategoriesViewModel(router: router)
        )
        
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            CustomToolBar(
                title: Resources.Text.categoriesTitle.localized(language),
                subTitle: changeText()
            )
            .padding(.top, 0)
            
            ScrollView {
                Spacer()
                LazyVGrid(
                    columns: Array(
                        repeating: .init(.flexible(),
                        spacing: Drawing.columnsSpacing),
                        count: Drawing.columnsCount
                    )
                )
                {
                    ForEach(Categories.allCases) { category in
                        Button(action: {
                            if viewModel.categories.contains(category) {
                                viewModel.categories.removeAll() { $0 == category }
                            } else {
                                viewModel.categories.append(category)
                            }
                            viewModel.saveCategories()
                            
                        })
                        {
                            HStack(spacing: Drawing.horizontalSpacing) {
                                Spacer()
                                Text(category.image)
                                Text(category.rawValue.localized(language))
                                
                                Spacer()
                            }
                            .foregroundStyle(
                                viewModel.categories.contains(category)
                                ? Color.white
                                : Color.black.opacity(0.6)
                            )
                            .font(.headline.bold())
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.vertical, Drawing.verticalSpacing)
                            .background(
                                viewModel.categories.contains(category)
                                ? DS.Colors.purpleDark
                                : DS.Colors.grayLighter)
                            .cornerRadius(Drawing.cornerRadius)
                        }
                    }
                }
                .padding()
            }
            Spacer()
            if mode == .onboarding {
                CustomButton(
                    title: "Choose".localized(language),
                    action: {
                        viewModel.categoryChosen()
                    },
                    buttonType: .mode,
                    isSelected: true
                    
                )
                .padding()
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadCategories()
        }
        
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
    }
    
    private func changeText() -> String {
        mode == .onboarding
        ? Resources.Text.selectOnboardingCategories.localized(language)
        : Resources.Text.selectCategories.localized(language)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(mode: .onboarding, router: StartRouter())
    }
}
