//
//  LoseViewController.swift
//  Millionaire
//
//  Created by Admin on 5.02.23.
//

import UIKit

class LoseViewController: UIViewController {

    var moneyWonCount: Int!

    @IBOutlet weak var looseDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        guard let moneyWonCount else { return }
        looseDescriptionLabel.text = "Ваш выигрыш составил \(moneyWonCount) рублей"

    }
    



}
