//
//  QuestionViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit

class QuestionViewController: UIViewController {
    
    
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var answerOne: UILabel!
    @IBOutlet weak var answerTwo: UILabel!
    @IBOutlet weak var answerThree: UILabel!
    @IBOutlet weak var answerFour: UILabel!
    
  
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        
    }
    
    let allQuestions = AllQuestions()
    var indexOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestion(index: indexOfQuestions)
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
