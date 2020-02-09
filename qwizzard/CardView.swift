//
//  CardView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct CardView: View {
    let term: Term
    var body: some View {
        VStack {
            Text(term.question)
            Text(term.answer)
        }
    }
    
    init(term: Term) {
        self.term = term
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(term: Term(question: "Stupid", answer: "having or showing a great lack of intelligence or common sense: I was stupid enough to think she was perfect."))
    }
}
