//
//  CardView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI
import Combine

enum Side {
    case front, back
    
    mutating func toggle() {
        switch self {
        case .front: self = .back
            break
        case .back: self = .front
            break
        }
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

class CardViewModel: ObservableObject, Identifiable {
    @Published var side: Side = .front
    
    var termId: UUID {
        term.id
    }
    
    let term: Term
    
    init(term: Term) {
        self.term = term
    }
}

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    @GestureState private var cardOffset = CGSize.zero
    var body: some View {
        
        VStack {
            VStack {
                ZStack {
                    if self.viewModel.side == .front {
                        Text(self.viewModel.term.question)
                    } else {
                        Text(self.viewModel.term.answer)
                            .scaleEffect(x: -1, y: 1)
                    }
                }
                .animation(Animation.linear(duration: 0.025).delay(0.25))
                .padding()
                .frame(maxWidth: 300, maxHeight: 300)
                
            }
            
        }
        .background(Color.green.shadow(radius: 2))
        .padding()
        .scaleEffect(x: self.viewModel.side == .front ? 1 : -1, y: 1)
        .offset(self.cardOffset)
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.5)) {
                self.viewModel.side.toggle()
            }
        }
        .gesture(
            DragGesture()
                .updating(self.$cardOffset) { (value, state, transaction) in
                    state = value.translation
                }
                .onEnded { v in
                    self.didDragCard(v.translation)
                }
        )
        
    }
    
    private let didDragCard: (_ offset: CGSize) -> Void
    
    init(_ viewModel: CardViewModel,
         didDragCard: @escaping (_ offset: CGSize) -> Void) {
        self.viewModel = viewModel
        self.didDragCard = didDragCard
    }
}

struct CardView_Previews: PreviewProvider {
    static var viewModel = CardViewModel(term: Term(question: "Stupid", answer: "having or showing a great lack of intelligence or common sense: I was stupid enough to think she was perfect."))
    
    static var previews: some View {
        VStack {
            CardView(viewModel, didDragCard: {_ in })
        }
    }
}
