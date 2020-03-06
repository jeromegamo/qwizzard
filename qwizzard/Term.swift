//
//  Term.swift
//  qwizzard
//
//  Created by Jerome Gamo on 2/9/20.
//  Copyright © 2020 Jerome Gamo. All rights reserved.
//
import Foundation

struct Term: Identifiable, Codable {
    let id = UUID()
    let question: String
    let answer: String
}
