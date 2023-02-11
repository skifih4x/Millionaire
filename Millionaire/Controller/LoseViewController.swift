//
//  LoseViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit

class LoseViewController: UIViewController {

    var moneyWonCount: Int!

    @IBOutlet weak var gameResultLabel: UILabel!
    @IBOutlet weak var looseDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
    }

    private func setupUI() {
        guard let moneyWonCount else { return }
        if moneyWonCount >= 1000_000 {
            gameResultLabel.text = "Won!"
            gameResultLabel.textColor = .systemGreen
        }
        looseDescriptionLabel.text = "Ваш выигрыш составил \(moneyWonCount) рублей"

    }
}
