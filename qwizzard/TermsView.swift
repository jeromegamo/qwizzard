//
//  QuizListView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/2/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct Term: Hashable {
    let question: String
    let answer: String
}

struct TermsView: View {
    
    @State var terms: [Term] = []
    var body: some View {
        NavigationView {
            List(terms.indices, id: \.self) { idx in
                
                NavigationLink(destination:
                    TermEditingView(toEdit: self.terms[idx],
                                    didEditTerm: { editedTerm in
                      
                    self.terms[idx] = editedTerm
                                        
                })) {
                    Text("\(self.terms[idx].question) - \(self.terms[idx].answer)")
                }
            }
            .navigationBarTitle(Text("Questions"), displayMode: .inline)
            .navigationBarItems(trailing:
                
                NavigationLink(destination:
                    
                    TermCreationView(didCreateTerm: { v in
                        self.terms.append(v)
                    })
                    
                ) {
                    Text("Add")
                }
                
            )
        }
    }
    
    mutating func addQuestion(question: Term) -> () {
        self.terms.append(question)
    }
    
    mutating func updateTerm(term: Term) -> () {
        
    }
    
    init() {
        terms.append(Term(
            question: "Question #1", answer: "Answer #1"))
        terms.append(Term(
            question: "Question #2", answer: "Answer #2"))
        terms.append(Term(
            question: "Question #3", answer: "Answer #3"))
        terms.append(Term(
            question: "Question #4", answer: "Answer #4"))
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TermsView()
        }
    }
}
