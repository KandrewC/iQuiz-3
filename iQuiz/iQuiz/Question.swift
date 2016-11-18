//
//  Question.swift
//  iQuiz
//
//  Created by Andrew Kan on 11/11/16.
//  Copyright © 2016 Andrew Kan. All rights reserved.
//

import Foundation


class Question {
    var question : String = ""
    var answer : String = ""
    
    var answers : [String]
    
    var answeredQuestion = false
    
    init(question: String, answer : String, answers: [String]){
        self.question = question
        self.answer = answer
        self.answers = answers
    }
    
    required init() {
        answers = []
    }
}
