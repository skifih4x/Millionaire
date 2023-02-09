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
    
    @IBOutlet weak var answerOne: UILabel!
    @IBOutlet weak var answerTwo: UILabel!
    @IBOutlet weak var answerThree: UILabel!
    @IBOutlet weak var answerFour: UILabel!
    
    @IBOutlet weak var answerOneBtn: UIButton!
    @IBOutlet weak var answerTwoBtn: UIButton!
    @IBOutlet weak var answerThreeBtn: UIButton!
    @IBOutlet weak var answerFourBtn: UIButton!
    @IBOutlet weak var fiftyFiftyButton: UIButton!
    
    @IBOutlet weak var hallHelpButton: UIButton!
    
    @IBOutlet weak var callFriendButton: UIButton!
    
    
    
    
    
    @IBOutlet var answersLbl: [UILabel]!
    @IBOutlet var answersBtn: [UIButton]!
    
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {
            
            isCorrect = true
        } else {
            isCorrect = false
        }
        
//
        
        presentScore(bool: isCorrect ?? false)
        
        answerIsChecking(name: "AnswerAccepted")
        
        answerTag = sender.tag
        answerIsChecking(name: "AnswerAccepted")
        
        for answer in answersBtn {
            answer.isEnabled = false
        }
    }
    
    private func presentScore(bool: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            let scoreVC = ScoreViewController(currentQuestion: self.currentQuestion, correct: bool)
            
        
            self.navigationController?.pushViewController(scoreVC, animated: false)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        answerIsChecking(name: "TimerSound")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getQuestion(index: currentQuestion)
        (answerOne.isHidden, answerTwo.isHidden, answerThree.isHidden, answerFour.isHidden) = (false, false, false, false)
        (answerOneBtn.isEnabled, answerTwoBtn.isEnabled, answerThreeBtn.isEnabled, answerFourBtn.isEnabled) = (true, true, true, true)
        
        getQuestion(index: currentQuestion)
        answerIsChecking(name: "TimerSound")
        numbOfQuestion.text = String(currentQuestion)
        cash.text = String(allQuestions.questions[currentQuestion].cash)
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
    
    
    @IBAction func hallHelpButtonPressed(_ sender: UIButton) {
        hallHelp()
        
        hallHelpButton.isEnabled = false
        hallHelpButton.alpha = 0.5
        
    }
    
    @IBAction func callFriendButtonPressed(_ sender: UIButton) {
        callFriend()
        
        callFriendButton.isEnabled = false
        callFriendButton.alpha = 0.5
        
    }
    
    
    
    
    
    @IBAction func fiftyFiftyButtonPressed(_ sender: UIButton) {
        getFiftyFifty()
        answerIsChecking(name: "FiftyFifty")
        fiftyFiftyButton.alpha = 0.5
        fiftyFiftyButton.isEnabled = false
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

