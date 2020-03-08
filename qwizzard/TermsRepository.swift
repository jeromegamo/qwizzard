//
//  TermsRepository.swift
//  qwizzard
//
//  Created by Jerome Gamo on 3/6/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//

enum TermRepository {
	typealias Save = (Term) -> SaveError?
	typealias GetAll = () -> [Term]
	
	enum SaveError: Error {
		case notSaved
	}
}

