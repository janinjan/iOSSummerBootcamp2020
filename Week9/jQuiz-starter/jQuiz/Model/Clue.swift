//
//  QuestionCodable.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

typealias Clue = [ClueElement]

struct ClueElement: Codable {
    let id: Int
    let points: Int?
    let answer: String
    let question: String?
    let categoryID: Int
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case id, answer, question, category
        case points = "value"
        case categoryID = "category_id"
    }
}

struct Category: Codable {
    let id: Int
    let title: String
    let cluesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title
        case cluesCount = "clues_count"
    }
}
