//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI


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

struct LearnView: View {
	
	@ObservedObject var viewModel : LearnViewModel
	
	init(viewModel: LearnViewModel) {
		self.viewModel = viewModel
		self.viewModel.loadTerms()
	}
	
	var body: some View {
		VStack {
			if self.viewModel.noCardsLeft {
				TermsCompleteView {
					self.viewModel.reset()
				}
			} else {
				cardViewStack()
			}
		}
	}
	
	func cardViewStack() -> some View {
		GeometryReader { g in
			ZStack {
				ForEach(self.viewModel.cardViewModels) { vm in
					CardView(vm, didDragCard: { offset in
						
						let threshold = g.frame(in: .global).size.width / 2
						
						let outOfBounds = abs(offset.width) > threshold
						
						if outOfBounds {
							self.viewModel.popCard()
						}
						
					})
						.zIndex(self.viewModel.isTopCard(vm) ? 1 : 0)
				}
			}
		}
	}
}

struct CardsView_Previews: PreviewProvider {
	static var previews: some View {
		LearnView(
			viewModel: LearnViewModel(
				getAllTerms: JSONTermsRepository.getAll))
	}
}
