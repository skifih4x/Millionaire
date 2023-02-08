//
//  Hints.swift
//  Millionaire
//
//  Created by Nikolai Zvonarev on 08.02.2023.
//

import UIKit
// расширение для выбора из массива неправильных ответов два ответа
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
extension QuestionViewController {
    
    func getFiftyFifty() {
        let numberOfRightAnswer: Int = allQuestions.questions[currentQuestion].rightAnswer
        let correctAnswer =
        allQuestions.questions[currentQuestion].answers[numberOfRightAnswer - 1]
        let wrongAnswers = allQuestions.questions[currentQuestion].answers.filter{$0 != correctAnswer}
        let pickTwoWA = wrongAnswers.choose(2)
        print(pickTwoWA)
        let firstWA = pickTwoWA[0]
        let secondWA = pickTwoWA[1]
        if answerOne.text == firstWA || answerOne.text == secondWA {
            answerOne.isHidden = true
        }; if answerTwo.text == firstWA || answerTwo.text == secondWA {
            answerTwo.isHidden = true
        }; if answerThree.text == firstWA || answerThree.text == secondWA {
            answerThree.isHidden = true
        }; if answerFour.text == firstWA || answerFour.text == secondWA {
            answerFour.isHidden = true}
    }
}
