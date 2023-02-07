//
//  QuestionViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit

class QuestionViewController: UIViewController {
    
    
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var answerOne: UIButton!
    @IBOutlet weak var answerTwo: UIButton!
    @IBOutlet weak var answerThree: UIButton!
    @IBOutlet weak var answerFour: UIButton!
    
    let allQuestions = AllQuestions()
    var indexOfQuestions = 0
    
    @IBAction func answerBtnPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    getQuestion(index: indexOfQuestions)
        
    }
    
    func getQuestion(index: Int) {
        questionLbl.text = allQuestions.questions[index].question
        questionLbl.numberOfLines = 0
        
        answerOne.setTitle(allQuestions.questions[index].answer1, for: .normal)
//        answerOne.titleLabel?.textAlignment = .right
        answerTwo.setTitle(allQuestions.questions[index].answer2, for: .normal)
        answerThree.setTitle(allQuestions.questions[index].answer3, for: .normal)
        answerFour.setTitle(allQuestions.questions[index].answer4, for: .normal)
    }
    

}
