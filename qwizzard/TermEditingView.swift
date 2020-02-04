//
//  TermEditingView.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/3/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import SwiftUI

struct TermEditingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var question: String = ""
    @State var answer: String = ""
    
    let didEditTerm : (Term) -> ()
    
    var body: some View {
        VStack {
            Group {
                TextField("Question: ", text: $question)
                TextField("Answer: ", text: $answer)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                self.didEditTerm(Term(
                    question: self.question, answer: self.answer))
                
                 self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            })
            
        }.navigationBarTitle(Text("Create"), displayMode: .inline)
    }
    
    init(toEdit: Term, didEditTerm: @escaping (Term) -> ()) {
        self.didEditTerm = didEditTerm
        self._question = State(initialValue: toEdit.question)
        self._answer = State(initialValue: toEdit.answer)
    }
}

struct TermEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditingView(toEdit: Term(question: "", answer: ""),
                        didEditTerm: {t in })
    }
}
