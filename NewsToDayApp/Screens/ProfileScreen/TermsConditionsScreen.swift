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
      Use for personal, non-commercial purposes. It is prohibited to offer services related to the use of the application to other users in order to make a profit.
      Intellectual property. The User acknowledges that the application, its interface and content are protected by copyright, trademarks, patents and other rights that belong to the developer or other legitimate copyright holders.
      The responsibility of the user. The user is solely responsible for his actions in using the application, including actions for posting and transmitting information, comments, images and other materials to other users using the application.
      Violations and consequences. For violations committed by the user, the developer has the right to refuse further provision of services or restrict such provision in whole or in part with or without notification to the user.
    """
    
    var textTermsConditionsRUS: String =
    """
  Использование в личных некоммерческих целях. Запрещается предлагать услуги, связанные с использованием приложения, другим пользователям в целях извлечения прибыли.
  Интеллектуальная собственность. Пользователь признаёт, что приложение, его интерфейс и содержание защищены авторским правом, товарными знаками, патентами и иными правами, которые принадлежат разработчику или иным законным правообладателям.
  Ответственность пользователя. Пользователь самостоятельно несёт ответственность за свои действия по использованию приложения, в том числе за действия по размещению и передаче информации, комментариев, изображений и иных материалов другим пользователям с помощью приложения.
  Нарушения и последствия. За нарушения, допущенные пользователем, разработчик вправе отказать ему в дальнейшем предоставлении услуг или ограничить такое предоставление полностью или частично с уведомлением пользователя или без такового.
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
