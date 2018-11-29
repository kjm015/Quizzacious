//
//  JSON.swift
//  Quizzacious
//
//  Created by Kevin Miyata on 11/29/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation
import UIKit

public struct Question: Decodable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
}

public struct Quiz: Decodable {
    var response_code: Int
    var results: [Question]
}
