//
//  LearnViewModel.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/11/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

class LearnViewModel: ObservableObject {
	private var terms: [Term] = []
	@Published var cardViewModels: [CardViewModel] = []
	@Published var noCardsLeft = false
	let getAllTerms: TermRepository.GetAll
	
	init(getAllTerms: @escaping TermRepository.GetAll) {
		self.getAllTerms = getAllTerms
	}
	
	func loadTerms() {
		self.terms = self.getAllTerms()
		self.cardViewModels = self.terms
			.prefix(2)
			.map { CardViewModel(term: $0) }
	}
	
	func reset() {
		self.loadTerms()
		self.noCardsLeft = false
	}
	
	func popCard() {
		self.terms.removeFirst()
		self.cardViewModels = self.terms
			.prefix(2)
			.map { CardViewModel(term: $0) }
		
		if self.terms.isEmpty {
			self.noCardsLeft = true
		}
	}
	
	func isTopCard(_ cardViewModel: CardViewModel) -> Bool {
		if let first = self.cardViewModels.first {
			return first.id == cardViewModel.id
		}
		
		return false
	}
}
