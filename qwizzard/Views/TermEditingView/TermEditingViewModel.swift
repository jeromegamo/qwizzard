//
//  TermEditingViewModel.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/10/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

class TermEditingViewModel: ObservableObject {
	@Published var question: String
	@Published var answer: String
	private let id: UUID
	private let order: Int
	private let didEditTerm : (Term) -> ()
	private let saveTerm: TermRepository.Save
	
	init(saveTerm: @escaping TermRepository.Save,
			 didEditTerm: @escaping (Term) -> (),
			 term: Term) {
		self.saveTerm = saveTerm
		self.didEditTerm = didEditTerm
		self.id = term.id
		self.question = term.question
		self.answer = term.answer
		self.order = term.order
	}
	
	func save() {
		let term = Term(id: self.id,
										question: self.question,
										answer: self.answer,
										order: self.order)
		
		if case (.none) = saveTerm(term) {
			didEditTerm(term)
		} else {
			//show error?
		}
	}
}
