//
//  JSONTermsRepository.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

enum JSONTermsRepository {
	
	static func save(term: Term) -> TermRepository.SaveError? {
		var terms = self.getAll()
		//TODO:- Throw exceptions
		guard let path = Bundle.main.path(forResource: "terms", ofType: ".json") else {
			return .some(.notSaved)
		}
		
		guard let itemIndex = terms.firstIndex(where: { $0.id == term.id }) else {
			return .some(.notSaved)
		}
		
		terms[itemIndex] = term
		
		let encoder = JSONEncoder()
		
		if let encodable = try? encoder.encode(terms) {
			_ = try? encodable.write(to: URL(fileURLWithPath: path), options: .atomic)
		}
		
		return .none
	}
	
	static func getAll() -> [Term] {
		//TODO:- Throw exceptions
		guard let path = Bundle.main.path(forResource: "terms", ofType: ".json") else {
			return []
		}
		
		guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
			return []
		}
		
		let decoder = JSONDecoder()
		
		guard let result = try? decoder.decode([Term].self, from: data) else {
			return []
		}
		
		return result
	}
}
