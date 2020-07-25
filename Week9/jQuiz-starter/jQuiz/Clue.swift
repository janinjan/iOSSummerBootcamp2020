//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

typealias Clue = [ClueElement]

struct ClueElement: Decodable {
    let id: Int
    let answer: String
    let question: String
    let category: Category
}

struct Category: Decodable {
    let id: Int
    let title: String
    let cluesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case cluesCount = "clues_count"
    }
}
