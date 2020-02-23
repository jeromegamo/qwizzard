//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

class TermRepository: ObservableObject {
    func getTerms() -> [Term]{
        return [
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

class LearnViewModel {
    var terms: [Term] = [
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

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing: return .zero
        case .dragging(translation: let value): return value
        }
    }
}

struct LearnView: View {
    @EnvironmentObject var termRepo: TermRepository
    
    @GestureState var dragState = DragState.inactive
    @State private var cardViews: [Term] = []
    
    let dragThreshold: CGFloat = 80
    var viewModel : LearnViewModel
    
    var body: some View {
        
        ZStack {
            ForEach(cardViews, id: \.self) { term in
                CardView(term: term)
                    .zIndex(self.isTopCard(term) ? 1 : 0)
                    .offset(self.isTopCard(term) ? self.dragState.translation : .zero)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .updating(self.$dragState, body: { (value, state, translation) in
                            switch value {
                            case .first(true):
                                state = .pressing
                            case .second(true, let drag):
                                state = .dragging(translation: drag?.translation ?? .zero)
                            default: break
                            }
                        })
                        .onEnded({ (v) in
                            guard case .second(true, let drag?) = v else {
                                return
                            }
                            print("\(drag.translation.width) - \(self.dragThreshold)")
                            if abs(drag.translation.width) > self.dragThreshold {
                                self.removeTopCard()
                            }
                        })
                    )       
            }
        }
        .onAppear {
            self.initialLoadOfCardViews()
        }
    }
    
    func initialLoadOfCardViews() {
        self.cardViews = Array(self.viewModel.terms.prefix(2))
    }
    
    func isTopCard(_ term: Term) -> Bool {
        guard let last = self.viewModel.terms.first else {
            return false
        }
        
        return last.question == term.question
    }

    func removeTopCard() {
        let _ = self.viewModel.terms.removeFirst()
        self.cardViews = Array(self.viewModel.terms.prefix(2))
    }
    
    init(viewModel: LearnViewModel) {
        self.viewModel = viewModel
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        
        LearnView(viewModel: LearnViewModel())
    }
}
