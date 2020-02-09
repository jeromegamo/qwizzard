//
//  Term.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/9/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//
struct Term: Hashable {
    let question: String
    let answer: String
    
    static func ==(lhs: Term, rhs: Term) -> Bool {
        return lhs.question == rhs.question
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.question)
    }
}
