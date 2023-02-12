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
    var fiftyFiftyPlayer: AVAudioPlayer!

    var audioPlayerTimer = Timer()
    
    let allQuestions = AllQuestions()
    var currentQuestion = 0
    var isCorrect: Bool?
    var answerTag: Int?
    
    var timer: Timer?
    var timeLeft = 30
    
    
    @IBOutlet weak var timerLabel: UILabel!
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
    
    @IBOutlet weak var takeCashLbl: UIButton!
    
    @IBAction func takeCurrentCash(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: title, message: "Уверены, что хотите забрать деньги?", preferredStyle: .alert)

        let action1 = UIAlertAction(title: "Да", style: .default) { action in
            
            let alertController = UIAlertController(title: self.title, message: "Ваш выигрыш: \(self.allQuestions.questions[self.currentQuestion].cash)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { action in
                self.dismiss(animated: true)
            }
            
            self.player.stop()
            self.timer?.invalidate()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let looseVC = storyboard.instantiateViewController(withIdentifier: "loseVC") as! LoseViewController
            self.navigationController?.pushViewController(looseVC, animated: true)
            
            alertController.addAction(action)
            self.present(alertController, animated: true)
            
        }
        let action2 = UIAlertAction(title: "Нет", style: .default) { action in
            self.dismiss(animated: true)
        }
        

        alertController.addAction(action1)
        alertController.addAction(action2)

        present(alertController, animated: true)
    }
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {

            isCorrect = true
        } else {
            isCorrect = false
        }

        currentQuestion += 1
        presentScore(bool: isCorrect ?? false)
        answerIsChecking(name: "AnswerAccepted")
        answerTag = sender.tag
        answerIsChecking(name: "AnswerAccepted")
        stopTimer()
        
        answersBtn.forEach {$0.isEnabled = false}
    }
    
    private func presentScore(bool: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            let scoreVC = ScoreViewController(currentQuestion: self.currentQuestion, isCorrect: bool)
            self.navigationController?.pushViewController(scoreVC, animated: false)
            self.stopTimer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerIsChecking(name: "TimerSound")
        navigationItem.hidesBackButton = true
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQuestion(index: currentQuestion)
        setButtonsBackToDefault()
        startTimer()
        

        answerIsChecking(name: "TimerSound")
        numbOfQuestion.text = ("Вопрос ") + String(currentQuestion + 1)
        cash.text = ("Сумма  ") + String(allQuestions.questions[currentQuestion].cash)
        
    }
    
    
    private func getQuestion(index: Int) {
        
        questionLbl.text = allQuestions.questions[index].question
        questionLbl.numberOfLines = 0
        
        takeCashLbl.setTitle("Забрать деньги", for: .normal)
        takeCashLbl.layer.cornerRadius = 20
        
        answersLbl[0].text = allQuestions.questions[index].answers[0]
        answersLbl[1].text = allQuestions.questions[index].answers[1]
        answersLbl[2].text = allQuestions.questions[index].answers[2]
        answersLbl[3].text = allQuestions.questions[index].answers[3]
    }

    private func setButtonsBackToDefault() {
        (answerOne.isHidden, answerTwo.isHidden, answerThree.isHidden, answerFour.isHidden) = (false, false, false, false)
        (answerOneBtn.isEnabled, answerTwoBtn.isEnabled, answerThreeBtn.isEnabled, answerFourBtn.isEnabled) = (true, true, true, true)
        answersBtn.forEach {$0.setBackgroundImage(UIImage(named: RectangleImages.blue.rawValue), for: .normal) }
    }
    private func answerIsChecking(name: String) {
        if name == "AnswerAccepted" {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            if isCorrect == true {
                audioPlayerTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkStopped), userInfo: nil, repeats: false)
            } else {
                audioPlayerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.checkStopped), userInfo: nil, repeats: false)
            }
        } else if name == "FiftyFifty" {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")

            fiftyFiftyPlayer = try! AVAudioPlayer(contentsOf: url!)
            fiftyFiftyPlayer.play()
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
    
    @objc private func checkStopped() {
        player.stop()
        timer?.invalidate()

        if isCorrect == true {
            answersBtn[answerTag! - 1].setBackgroundImage(UIImage(named: RectangleImages.green.rawValue), for: .normal)
            answerIsChecking(name: "CorrectAnswer")
        } else {
            answersBtn[answerTag! - 1].setBackgroundImage(UIImage(named: RectangleImages.red.rawValue), for: .normal)
            answerIsChecking(name: "WrongAnswer")
            answersBtn[allQuestions.getRightAnswerIndex(questionNumber: currentQuestion)].setBackgroundImage(UIImage(named: RectangleImages.green.rawValue), for: .normal)
        }
    }
    private  func startTimer () {
        timeLeft = 30
        timerLabel.text = "\(timeLeft)"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }

    @objc private func onTimer () {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft)"

        if timeLeft <= 0 {
            stopTimer()
            timeIsOver(isCorrect: false)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    private func timeIsOver(isCorrect: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let scoreVC = ScoreViewController(currentQuestion: self.currentQuestion, isCorrect: isCorrect)
            self.navigationController?.pushViewController(scoreVC, animated: false)
        }
    }
    
}

