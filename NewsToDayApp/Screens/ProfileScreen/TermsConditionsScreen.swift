//
//  TermsConditionsScreen.swift
//  NewsToDayApp
//
//  Created by Evgeniy Kislitsin on 28.10.2024.
//

import SwiftUI

struct TermsConditionsScreen: View {
    @AppStorage("selectedLanguage") private var language = LocalizationManager.shared.language
    @Environment(\.presentationMode) var presentationMode
        
    var textTermsConditions: String =
     """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

    Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

    Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

    Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.
    """
    
    #warning("Переписать условия :)) ")
    
    var textTermsConditionsRUS: String =
    """
    Бред какой то ;))) 
    История о том, как мы должны сидеть сложа руки, о том, как мы относимся к элите, как мы относимся к временным происшествиям, труду и великой долоре. Мы делаем все возможное, чтобы свести к минимуму последствия, которые могут возникнуть в результате наших усилий. Из-за этого я испытываю острую боль в порицании, и в сладострастии чувствую, что страдаю от этого, но избегаю этого.
    За исключением случаев, когда купидон не является сотрудником, виновный в том, что он дезертировал с работы.

    Когда мы видим, что все сущее - это естественная ошибка, мы испытываем сладострастие, обвиняем, скорбим, восхваляем, все, что осталось, - это то, что нужно для верного изобретателя и квазиархитектуры, чтобы описать биографию без объяснения причин.

    Немо понимает, что такое сладострастие, когда сладострастие становится естественным, когда оно исчезает, когда оно становится следствием великой долорес, и что такое естественное сладострастие, когда оно исчезает.

    Никогда не забывай, что есть, что такое скорбь, и что такое страдание, когда ты сидишь рядом, консекрет, адипиши велит, чтобы не было никаких других временных происшествий, связанных с трудом и великой скорбью, вызванной сладострастием.
"""
    
    var body: some View {
        VStack {
            
            ProfileTitle(title: "Terms & Conditions".localized(language), type: .withBackButton)
                .padding(.top, 68)
                .padding(.horizontal, 20)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text(language == .en ? textTermsConditions : textTermsConditionsRUS)
                        .font(.interRegular(16))
                        .foregroundColor(DS.Colors.grayDark)
                        .lineSpacing(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 20) // отступы слева и справа по 20
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .background(.background)
        .ignoresSafeArea()
        
    }
}


struct Terms_Previews: PreviewProvider {
    static var previews: some View {
        TermsConditionsScreen()
    }
}
