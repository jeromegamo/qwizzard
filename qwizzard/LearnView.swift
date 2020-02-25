//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

class LearnViewModel: ObservableObject {
    @Published var terms: [Term] = []
    
    func reload() {
        self.getTerms()
    }
    
    init() {
        getTerms()
    }
    
    private func getTerms() {
        terms = [
            Term(
            question: "Question #1", answer: "Answer #1"),
            Term(
            question: "Question #2", answer: "Answer #2"),
            Term(
            question: "Question #3", answer: "Answer #3"),
            Term(
            question: "Question #4", answer: "Answer #4")
        ]
    }
}

struct LearnView: View {
    @State private var noCardsLeft = false
    @State private var cardViewModels: [CardViewModel] = []
    
    var viewModel : LearnViewModel
    
    var body: some View {
        VStack {
            if noCardsLeft {
                TermsCompleteView {
                    self.viewModel.reload()
                    self.cardViewModels = Array(
                        self.viewModel
                            .terms
                            .prefix(2)
                            .map { CardViewModel(term: $0) })
                    
                    self.noCardsLeft = false
                }
            } else {
                cardViewStack()
            }
        }

    }
    
    init(viewModel: LearnViewModel) {
        self.viewModel = viewModel
        
        self._cardViewModels =
            State(initialValue: self.viewModel.terms.prefix(2)
                .map({ CardViewModel(term: $0)}))
    }
    
    func cardViewStack() -> some View {
        GeometryReader { g in
            ZStack {
                ForEach(self.cardViewModels) { vm in
                    CardView(vm, didDragCard: { offset in
                        
                        let threshold = g.frame(in: .global).size.width / 2
                        
                        self.didDragCard(offset: offset,
                                         threshold: threshold)

                    })
                    .zIndex(self.isTopCard(vm) ? 1 : 0)
                }
            }
        }
    }
    
    func removeCard() {
        _ = self.viewModel.terms.removeFirst()
        self.cardViewModels = Array(
            self.viewModel.terms
                .prefix(2)
                .map { CardViewModel(term: $0) })
    }
    
    func isTopCard(_ cardViewModel: CardViewModel) -> Bool {
        if let first = self.cardViewModels.first {
            return first.id == cardViewModel.id
        }
        
        return false
    }
    
    func didDragCard(offset: CGSize, threshold: CGFloat) {
        
        let outOfBounds = abs(offset.width) > threshold
        
        if outOfBounds {
            self.removeCard()
            
            if self.viewModel.terms.isEmpty {
                self.noCardsLeft = true
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        
        LearnView(viewModel: LearnViewModel())
    }
}
