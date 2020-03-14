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



struct CardView: View {
    @ObservedObject var vm: CardViewModel
    @GestureState private var cardOffset = CGSize.zero
    var body: some View {
        
        VStack {
            VStack {
                ZStack {
                    if self.vm.side == .front {
											Text(self.vm.term.question)
                    } else {
                        Text(self.vm.term.answer)
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
        .scaleEffect(x: self.vm.side == .front ? 1 : -1, y: 1)
        .offset(self.cardOffset)
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.5)) {
                self.vm.side.toggle()
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
        self.vm = viewModel
        self.didDragCard = didDragCard
    }
}

struct CardView_Previews: PreviewProvider {
    static var viewModel = CardViewModel(term:
			Term(question: "Stupid",
					 answer: "having or showing a great lack of intelligence or common sense: I was stupid enough to think she was perfect.",
					 order: 0))
    
    static var previews: some View {
        VStack {
            CardView(viewModel, didDragCard: {_ in })
        }
    }
}
