//
//  CardsView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct CardsView: View {
    @State private var circlePosition = CGPoint.zero
    
    @GestureState<[CGSize]> private var dictOffset : [CGSize]
    @State private var cards: [Term]
    @State private var didReachEnd = false
    var body: some View {
        GeometryReader { g in
            if self.didReachEnd {
                TermsCompleteView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                self.cardViews(g: g)
            }
        }
    }
    
    init() {
        let terms = [
            Term(
            question: "Question #1", answer: "Answer #1"),
            Term(
            question: "Question #2", answer: "Answer #2"),
            Term(
            question: "Question #3", answer: "Answer #3"),
            Term(
            question: "Question #4", answer: "Answer #4")
        ]
        
        self._cards = State(initialValue: terms)
       
        self._dictOffset =  GestureState(initialValue: Array(repeating: CGSize.zero, count: terms.count))
    }
    
    func isOverbounds(value: DragGesture.Value) -> Bool {
        // TODO: Should also include y axis
        abs(value.startLocation.x - value.location.x) > 100
    }
    
    func cardViews(g: GeometryProxy) -> some View {
        ZStack {
            ForEach(self.cards.indices, id: \.self) { c in
                
                CardView(term: self.cards[c])
                    .frame(width: g.size.width,
                           height: g.size.height)
                    .background(Color.green)
                    .offset(self.dictOffset[c])
                    .gesture(DragGesture()
                        .updating(self.$dictOffset, body: { (value, state, transaction) in
                            state[c] = value.translation
                        })
                        .onChanged({ (value) in
                            if self.isOverbounds(value: value) {
                                _ = self.cards.popLast()
                            }
                            
                            if self.cards.count == 1 {
                                self.didReachEnd = true
                            }
                        }))
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
