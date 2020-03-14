//
//  TermsListViewModel.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/10/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

class TermsListViewModel: ObservableObject {
	@Published var terms: [Term] = []
	
	let getAllTerms: TermRepository.GetAll
	let saveTerm: TermRepository.Save
	let createTerm: TermRepository.Create
	let deleteTerm: TermRepository.Delete
	
	init(
		getAllTerms: @escaping TermRepository.GetAll,
		saveTerm: @escaping TermRepository.Save,
		createTerm: @escaping TermRepository.Create,
		deleteTerm: @escaping TermRepository.Delete) {
		self.getAllTerms = getAllTerms
		self.saveTerm = saveTerm
		self.createTerm = createTerm
		self.deleteTerm = deleteTerm
	}
	
	func delete(indexSet: IndexSet) {
		guard let index = indexSet.first else {
			return
		}
		
		let toDelete = terms[index]
		if case .none = self.deleteTerm(toDelete) {
			terms.remove(atOffsets: indexSet)
		}
	}
	
	func loadTerms() {
		terms = getAllTerms()
	}
}
