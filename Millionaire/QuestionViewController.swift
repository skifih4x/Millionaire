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
    var rightAnswer: Bool?
    
    @IBAction func answerBtnPressed(_ sender: UIButton) {
        if sender.tag == allQuestions.questions[indexOfQuestions].rightAnswer {
            rightAnswer = true
        } else {
            rightAnswer = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    getQuestion(index: indexOfQuestions)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: LevelPlayerViewController = segue.destination as! LevelPlayerViewController
        
        if rightAnswer == true {
            destinationVC.rightAnswer = true
        } else {
            destinationVC.rightAnswer = false
        }
        
        destinationVC.indexOfQuestions = indexOfQuestions
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
