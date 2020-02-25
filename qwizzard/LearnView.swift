//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

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
    
    func reloadData() {
        self.terms = [
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
    @GestureState var dragState = DragState.inactive
    @State private var cardViews: [Term] = []
    @State private var noCardsLeft = false
    
    let dragThreshold: CGFloat = 80
    var viewModel : LearnViewModel
    
    fileprivate func cardViewsStack() -> some View {
        return ZStack {
            ForEach(cardViews) { term in
                CardView(term: term)
                    .zIndex(self.isTopCard(term) ? 1 : 0)
                    .offset(self.isTopCard(term) ? self.dragState.translation : .zero)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating(self.$dragState, body: self.dragUpdate)
                            .onEnded(self.dragDidEnd)
                )
            }
        }
        .onAppear {
            self.initialLoadOfCardViews()
        }
    }
    
    var body: some View {
        VStack {
            if noCardsLeft {
                TermsCompleteView {
                    self.viewModel.reloadData()
                    self.initialLoadOfCardViews()
                    self.noCardsLeft = false
                }
            } else {
                cardViewsStack()
            }
        }
    }
    
    private func initialLoadOfCardViews() {
        self.cardViews = Array(self.viewModel.terms.prefix(2))
    }
    
    private func isTopCard(_ term: Term) -> Bool {
        guard let last = self.viewModel.terms.first else {
            return false
        }
        
        return last.question == term.question
    }

    private func removeTopCard() {
        let _ = self.viewModel.terms.removeFirst()
        self.cardViews = Array(self.viewModel.terms.prefix(2))
    }
    
    private func dragUpdate(
        _ value: SequenceGesture<LongPressGesture, DragGesture>.Value,
        _ state: inout DragState,
        _ translation: inout Transaction) -> Void {
        
        switch value {
        case .first(true):
            state = .pressing
        case .second(true, let drag):
            state = .dragging(translation: drag?.translation ?? .zero)
        default: break
        }
    }
    
    private func dragDidEnd(
        _ value: SequenceGesture<LongPressGesture,
                                 DragGesture>.Value) {
        
        guard case .second(true, let drag?) = value else {
            return
        }
        
        if abs(drag.translation.width) > self.dragThreshold {
            self.removeTopCard()
        }
        
        if self.cardViews.isEmpty {
            self.noCardsLeft = true
        }
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
