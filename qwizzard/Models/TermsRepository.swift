//
//  TermsRepository.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

enum TermRepository {
	typealias Save = (Term) -> SaveError?
	typealias Create = (Term) -> CreateError?
	typealias GetAll = () -> [Term]
	typealias Delete = (Term) -> DeleteError?
	typealias GetNextOrderNumber = () -> Int
	
	//TODO: Refactor returned errors, I have no idea yet. Not familiar
	enum SaveError: Error {
		case notSaved
	}
	
	enum CreateError: Error {
		case notCreated
	}
	
	enum DeleteError: Error {
		case notDeleted
	}
}

