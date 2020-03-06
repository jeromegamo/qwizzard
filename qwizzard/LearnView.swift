//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

class TermsRepository {
    func getAll() -> [Term] {
        //TODO:- Throw exceptions
        guard let path = Bundle.main.path(forResource: "terms", ofType: ".json") else {
            return []
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return []
        }
        
        let encoder = JSONDecoder()
        
        guard let result = try? encoder.decode([Term].self, from: data) else {
            return []
        }
        
        return result
    }
}

class LearnViewModel: ObservableObject {
    @Published var terms: [Term] = []
    @Published var cardViewModels: [CardViewModel] = []
    @Published var noCardsLeft = false
    
    let termsRepository: TermsRepository
    
    init(termRepository: TermsRepository) {
        self.termsRepository = termRepository

    }
    
    func loadTerms() {
        self.terms = self.termsRepository.getAll()
        self.cardViewModels = self.terms
                                  .prefix(2)
                                  .map { CardViewModel(term: $0)}
    }
    
    func reset() {
        self.cardViewModels = self.terms
                                  .prefix(2)
                                  .map { CardViewModel(term: $0)}
        self.noCardsLeft = false
    }

    func popCard() {
        self.terms.removeFirst()
        self.cardViewModels = self.terms
                                  .prefix(2)
                                  .map { CardViewModel(term: $0)}
        
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
        
        LearnView(viewModel:
            LearnViewModel(termRepository:
                TermsRepository()))
    }
}
