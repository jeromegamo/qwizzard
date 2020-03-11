//
//  JSONTermsRepository.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

import Foundation

enum JSONTermsRepository {
	
	static private var path: String? = {
		return Bundle.main.path(forResource: "terms", ofType: ".json")
	}()
	
	static func delete(term: Term) -> TermRepository.DeleteError? {
		guard let path = path else {
			return .notDeleted
		}
		
		var terms = getAll()
		
		guard let index = terms.firstIndex(where: { $0.id == term.id }) else {
			return .notDeleted
		}
		
		terms.remove(at: index)
		
		let encoder = JSONEncoder()
		
		do {
			let encodable = try encoder.encode(terms)
			try encodable.write(to: URL(fileURLWithPath: path), options: .atomic)
			return .none
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func create(term: Term) -> TermRepository.CreateError? {
		guard let path = path else {
			return .notCreated
		}
		
		let terms = getAll()
		let newTerms = terms + [term]

		let encoder = JSONEncoder()
		do {
			let encodable = try encoder.encode(newTerms)
			try encodable.write(to: URL(fileURLWithPath: path), options: .atomic)
			return .none
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func save(term: Term) -> TermRepository.SaveError? {
		var terms = self.getAll()
		
		guard let path = path else {
			return .notSaved
		}
		
		guard let itemIndex = terms.firstIndex(where: { $0.id == term.id }) else {
			return .notSaved
		}
		
		terms[itemIndex] = term
		
		let encoder = JSONEncoder()
		do {
			let encodable = try encoder.encode(terms)
			try encodable.write(to: URL(fileURLWithPath: path),
													options: .atomic)
			return .none
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	static func getAll() -> [Term] {
		guard let path = path else {
			return []
		}
		
		let decoder = JSONDecoder()
		
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path))
			return try decoder.decode([Term].self, from: data)
		} catch {
			fatalError(error.localizedDescription)
		}
	}
}
