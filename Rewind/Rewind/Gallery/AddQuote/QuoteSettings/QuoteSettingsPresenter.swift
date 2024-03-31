//
//  QuoteSettingsPresenter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 12.03.2024.
//

import Foundation

final class QuoteSettingsPresenter {
    private weak var view: QuoteSettingsViewController?
    
    init(view: QuoteSettingsViewController?) {
        self.view = view
    }
    
    func viewDidLoad() {
        let quoteModel = view?.addQuoteVC?.presenter?.quote
        view?.configureUIForSavedData(quote: quoteModel?.text, author: quoteModel?.author)
    }
    
    func continueButtonTapped(quoteText: String?, author: String?) {
        guard let quoteText = quoteText, Validator.isValidQuote(quoteText) else {
            AlertHelper.showAlert(from: view, withTitle: "Error", message: "Invalid quote text")
            return
        }
        
        view?.addQuoteVC?.presenter?.quote.text = quoteText
        view?.addQuoteVC?.presenter?.quote.author = author
        view?.dismiss(animated: true) { [weak self] in
            self?.view?.addQuoteVC?.presenter?.generateQuoteImage()
        }
    }
}
