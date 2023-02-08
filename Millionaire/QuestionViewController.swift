//
//  QuestionViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit

class QuestionViewController: UIViewController {
    
    let allQuestions = AllQuestions()
    var currentQuestion = 0
    var isCorrect: Bool?
    
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var answerOne: UILabel!
    @IBOutlet weak var answerTwo: UILabel!
    @IBOutlet weak var answerThree: UILabel!
    @IBOutlet weak var answerFour: UILabel!
    
  
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {
            isCorrect = true
        } else {
            isCorrect = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestion(index: currentQuestion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: ScoreViewController = segue.destination as! ScoreViewController
        
        if isCorrect == true {
            destinationVC.isCorrect = true
        } else {
            destinationVC.isCorrect = false
        }
        
        destinationVC.currentQuestion = currentQuestion
    }
    
    func getQuestion(index: Int) {
        
        questionLbl.text = allQuestions.questions[index].question
        questionLbl.numberOfLines = 0
        
        answerOne.text = allQuestions.questions[index].answers[0]
        answerTwo.text = allQuestions.questions[index].answers[1]
        answerThree.text = allQuestions.questions[index].answers[2]
        answerFour.text = allQuestions.questions[index].answers[3]
    }

}
