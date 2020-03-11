//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct LearnView: View {
	
	@ObservedObject var vm : LearnViewModel
	
	init(_ viewModel: LearnViewModel) {
		self.vm = viewModel
	}
	
	var body: some View {
		VStack {
			if self.vm.noCardsLeft {
				TermsCompleteView {
					self.vm.reset()
				}
			} else {
				cardViewStack()
			}
		}
		.onAppear {
			self.vm.loadTerms()
		}
	}
	
	func cardViewStack() -> some View {
		GeometryReader { g in
			ZStack {
				ForEach(self.vm.cardViewModels) { vm in
					CardView(vm, didDragCard: { offset in
						
						let threshold = g.frame(in: .global).size.width / 2
						
						let outOfBounds = abs(offset.width) > threshold
						
						if outOfBounds {
							self.vm.popCard()
						}
						
					})
						.zIndex(self.vm.isTopCard(vm) ? 1 : 0)
				}
			}
		}
	}
}

struct CardsView_Previews: PreviewProvider {
	static var previews: some View {
		LearnView(
			LearnViewModel(
				getAllTerms: JSONTermsRepository.getAll))
	}
}
