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
            answerOneBtn.isEnabled = false
        }; if answerTwo.text == firstWA || answerTwo.text == secondWA {
            answerTwo.isHidden = true
            answerTwoBtn.isEnabled = false
        }; if answerThree.text == firstWA || answerThree.text == secondWA {
            answerThree.isHidden = true
            answerThreeBtn.isEnabled = false
        }; if answerFour.text == firstWA || answerFour.text == secondWA {
            answerFour.isHidden = true
            answerFourBtn.isEnabled = false
        }
    }
    
    //AlertController для подсказок
        func hintsAlert(title: String, message: String, textField: UITextField? = nil) {
           let alertFriends = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default) {_ in
               textField?.text = nil
           }
            alertFriends.addAction(okAction)
           present(alertFriends, animated: true)
            
       }
        
    //Подсказка "Звонок другу, где друг с вероятнорстью 80% даст правильный ответ.
        func callFriend() {
            let numberOfRightAnswer: Int = allQuestions.questions[currentQuestion].rightAnswer
            let rightAnswer = allQuestions.questions[currentQuestion].answers[numberOfRightAnswer - 1]
            let errorArray = allQuestions.questions[currentQuestion].answers.filter{$0 != rightAnswer}
            let error = errorArray.randomElement()
            
            // определяем вероятность
            let randomNumbers = Int.random(in: 1...11)
            
        //правильный ответ если сработала вероятность от 80%
            if randomNumbers <= 8 {
                hintsAlert(title: "Друг говорит:", message: "Я думаю это - \(rightAnswer)")
            } else {
                hintsAlert(title: "Друг говорит:", message: "Мне кажется это - \(error ?? " ") ")
            }
            
        }
        
        
    //Подсказка помощь зала, где зал с вероятность 70% отдаст большинство голосов за правильный ответ
        func correctAnswers() -> [Int] {
            var numberOfRightAnswer = allQuestions.questions[currentQuestion].rightAnswer
       
    // Если срабатывает вероятность 30% подменяем индекс правильного ответа на рандомный неправильный
            if Int.random(in: 0...3) == 0 {
                numberOfRightAnswer = [1, 2, 3, 4].filter{$0 != numberOfRightAnswer}.randomElement()!
            }
            

        var newArray = [0, 0, 0, 0]
    // Из массива ответов удаляем правильный ответ (возможно замененный выше)
        let errorArray = [1, 2, 3, 4].filter{$0 != numberOfRightAnswer}
        for _ in 1...100 {
    //С вероятностью 70% каждый человек из 100 отдаст голос за верный ответ
            let randomNumbers = Int.random(in: 1...11)
            if randomNumbers <= 6 {
                // проголосовали за верный ответ
                newArray[numberOfRightAnswer - 1] += 1
            } else {
                //проголосовали за неверный ответ
                newArray[errorArray.randomElement()!-1] += 1
            }
                
            }
            return newArray
        }
        
        
        func hallHelp() {
            
            let votes: [Int] = correctAnswers()

            hintsAlert(title: "Зал проголосовал:",
                      message: "\(allQuestions.questions[currentQuestion].answers[0]) -  \(votes[0])% \n \(allQuestions.questions[currentQuestion].answers[1]) -  \(votes[1])% \n \(allQuestions.questions[currentQuestion].answers[2]) -  \(votes[2])% \n \(allQuestions.questions[currentQuestion].answers[3]) - \(votes[3])%")
        }
    }
    
    
    

