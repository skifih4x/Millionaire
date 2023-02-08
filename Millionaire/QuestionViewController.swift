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
    
  
    
    @IBAction func answerBtnPresesd(_ sender: UIButton) {
        if sender.tag == allQuestions.questions[currentQuestion].rightAnswer {
            isCorrect = true
        } else {
            isCorrect = false
        }
        playSound(name: "AnswerAccepted")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getQuestion(index: currentQuestion)
        playSound(name: "TimerSound")
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
    
    @objc func stopSound() {
        player.stop()
        if isCorrect == true {
            playSound(name: "CorrectAnswer")
        } else {
            playSound(name: "WrongAnswer")
        }
    }

}
