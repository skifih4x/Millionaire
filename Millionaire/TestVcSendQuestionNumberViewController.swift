//
//  TestVcSendQuestionNumberViewController.swift
//  test
//
//  Created by Aleksey Kosov on 06.02.2023.
//

import UIKit

class TestVcSendQuestionNumberViewController: UIViewController {

    @IBOutlet weak var switchRightAnswer: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var number: Int?
    

    @IBAction func sendNumber(_ sender: UIButton) {
        if let num = Int((sender.titleLabel?.text)!) {
            print(num)

            let correct = switchRightAnswer.isOn

            let scoreVC = ScoreViewController(currentQuestion: num, correct: correct)
            scoreVC.view.backgroundColor = .clear
            scoreVC.modalPresentationStyle = .fullScreen

            navigationController?.pushViewController(scoreVC, animated: false)
        }


    }
}
