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
    
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var answerOne: UILabel!
    @IBOutlet weak var answerTwo: UILabel!
    @IBOutlet weak var answerThree: UILabel!
    @IBOutlet weak var answerFour: UILabel!

    @IBOutlet weak var fiftyFiftyButton: UIButton!
 
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {
            print(allQuestions.questions[currentQuestion])
            isCorrect = true
        } else {
            isCorrect = false
        }
        currentQuestion += 1
        
        presentScore(bool: isCorrect ?? false)
        
        playSound(name: "AnswerAccepted")
        
        
    }
    
    private func presentScore(bool: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let scoreVC = ScoreViewController(currentQuestion: self.currentQuestion, correct: bool)
            
            
            self.navigationController?.pushViewController(scoreVC, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        playSound(name: "TimerSound")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getQuestion(index: currentQuestion)
    }
    
    func getQuestion(index: Int) {
        
        questionLbl.text = allQuestions.questions[index].question
        questionLbl.numberOfLines = 0
        
        answerOne.text = allQuestions.questions[index].answers[0]
        answerTwo.text = allQuestions.questions[index].answers[1]
        answerThree.text = allQuestions.questions[index].answers[2]
        answerFour.text = allQuestions.questions[index].answers[3]
    }
    
    func playSound(name: String) {
        if name == "AnswerAccepted" {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            audioPlayerTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.stopSound), userInfo: nil, repeats: false)
        } else {
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
    @IBAction func fiftyFiftyButtonPressed(_ sender: UIButton) {
        getFiftyFifty()
        playSound(name: "FiftyFifty")
        fiftyFiftyButton.alpha = 0.5
        fiftyFiftyButton.isEnabled = false
    }
    @objc func stopSound() {
        player.stop()
        if isCorrect == true {
            playSound(name: "CorrectAnswer")
        } else {
            playSound(name: "WrongAnswer")
        }
    }
}
