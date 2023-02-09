//
//  QuestionViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit
import AVFoundation

class QuestionViewController: UIViewController {
    
    var player: AVAudioPlayer!
    var audioPlayerTimer = Timer()

    let allQuestions = AllQuestions()
    var currentQuestion = 0
    var isCorrect: Bool?
    var answerTag: Int?
    
    
    @IBOutlet weak var cash: UILabel!
    @IBOutlet weak var numbOfQuestion: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet var answersLbl: [UILabel]!
    @IBOutlet var answersBtn: [UIButton]!
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {
            isCorrect = true
        } else {
            isCorrect = false
        }
        answerTag = sender.tag
        answerIsChecking(name: "AnswerAccepted")
        
        for answer in answersBtn {
            answer.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getQuestion(index: currentQuestion)
        answerIsChecking(name: "TimerSound")
        numbOfQuestion.text = String(currentQuestion)
        cash.text = String(allQuestions.questions[currentQuestion].cash)
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
        
        answersLbl[0].text = allQuestions.questions[index].answers[0]
        answersLbl[1].text = allQuestions.questions[index].answers[1]
        answersLbl[2].text = allQuestions.questions[index].answers[2]
        answersLbl[3].text = allQuestions.questions[index].answers[3]
    }
    
    func answerIsChecking(name: String) {
        if name == "AnswerAccepted" {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            if isCorrect == true {
                audioPlayerTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkStopped), userInfo: nil, repeats: false)
            } else {
                audioPlayerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.checkStopped), userInfo: nil, repeats: false)
            }
            
        } else {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
    @objc func checkStopped() {
        player.stop()
    
        if isCorrect == true {
            answersBtn[answerTag! - 1].setBackgroundImage(UIImage(named: "RectangleGreen"), for: .normal)
            answerIsChecking(name: "CorrectAnswer")
        } else {
            answersBtn[answerTag! - 1].setBackgroundImage(UIImage(named: "RectangleRed"), for: .normal)
            answerIsChecking(name: "WrongAnswer")
            answersBtn[allQuestions.questions[currentQuestion].rightAnswer - 1].setBackgroundImage(UIImage(named: "RectangleGreen"), for: .normal)
        }
        answersBtn[answerTag! - 1].isEnabled = true
        answersBtn[allQuestions.questions[currentQuestion].rightAnswer - 1].isEnabled = true
    }

}
