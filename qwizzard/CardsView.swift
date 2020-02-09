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
    
    var body: some View {
        GeometryReader { g in
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
                                    print("Outside") // TODO: remove in the future
                                    self.cards.popLast()
                                } else {
                                    print("Inside") // TODO: Remove in the future
                                }
                            }))
                }
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
    
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
    }
}
