//
//  ViewController.swift
//  test
//
//  Created by Aleksey Kosov on 06.02.2023.
//

import UIKit

class ScoreViewController: UIViewController {
    
     var currentQuestion: Int!
     var isCorrect: Bool!

    private var moneyWon: Int = 0

    private let allQuestions = AllQuestions()

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()

    lazy var takeMoneyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Забрать деньги", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3017496034, green: 0.1880411259, blue: 0.5, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(takeMoneyPressed), for: .touchUpInside)
        return button
    }()

    
    lazy var overallStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var continieTapView: UIView = {
        let tapView = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажмите, чтобы продолжить"
        label.textColor = .systemBackground
        tapView.addSubview(label)
        tapView.translatesAutoresizingMaskIntoConstraints = false
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContiniueView)))
        tapView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: tapView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: tapView.centerYAnchor)
        ])
        
        return tapView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true

        setupUI()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(currentQuestion: Int, isCorrect: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.currentQuestion = currentQuestion
        self.isCorrect = isCorrect
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForLoose(currentQuestion: currentQuestion)
    }

    @objc func takeMoneyPressed() {
        let alert = UIAlertController(title: "Забрать деньги?", message: "Вы уверены?", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Да", style: .default) { _ in
            let moneyCount = self.allQuestions.getQuestionCash(questionNumber: self.currentQuestion)
            self.presentDefaultAlert(title: "Вы забрали деньги",
                                     text: "Сумма \(moneyCount)",
                                     buttonText: "Попробовать еще?", with: moneyCount)
        }

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)

    }
    
    
    @objc func didTapContiniueView() {
        navigationController?.popViewController(animated: false)
    }
    
    private func createStacksWithQuestions() {
        stride(from: 15, to: 0, by: -1) .forEach { num in
            overallStackView.addArrangedSubview(createViewWithQuestion(questionNumber: num,
                                                                       moneycount: allQuestions.getQuestionCash(questionNumber: num)))
        }
    }


    private func showWinnerAnimation() {
        for (index, view) in overallStackView.arrangedSubviews.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(index)) {
                self.flashingAnimation(in: view)
            }
        }
    }
    
    private func checkForLoose(currentQuestion: Int) {
        var currentQuestion = currentQuestion

        if !isCorrect {
            presentDefaultAlert(title: "Вы проиграли", text: "Хотите попробовать еще раз?",
                                buttonText: "Попробовать еще раз")
        } else {
            currentQuestion += 1
        }
        switch currentQuestion {
        case 1...5:
            self.moneyWon = 0
        case 6...10:
            self.moneyWon = 1000
        case 11...15:
            self.moneyWon = 32000
        case 16: self.moneyWon = 1000_000
            presentDefaultAlert(title: "Вы победили!", text: "Хотите попробовать еще раз?",
            buttonText: "Попробовать еще раз")
            showWinnerAnimation()
        default: break

        }
    }

    private func presentDefaultAlert(title: String, text: String, buttonText: String, with moneyCount: Int? = nil) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)

        let action = UIAlertAction(title: buttonText, style: .default) { action in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let looseVC = storyboard.instantiateViewController(withIdentifier: "loseVC") as! LoseViewController
            if let moneyCount = moneyCount {
                looseVC.moneyWonCount = moneyCount
            } else {
                looseVC.moneyWonCount = self.moneyWon
            }

            self.navigationController?.pushViewController(looseVC, animated: true)
        }

        alertController.addAction(action)

        present(alertController, animated: true)

    }

    
    private func setupUI() {
        setBackground(in: view, with: "background")
        
        view.addSubview(overallStackView)
        view.addSubview(continieTapView)
        view.addSubview(takeMoneyButton)
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([

            takeMoneyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            takeMoneyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            takeMoneyButton.heightAnchor.constraint(equalToConstant: 40),
            takeMoneyButton.widthAnchor.constraint(equalToConstant: 150),

            logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logoImageView.centerYAnchor.constraint(equalTo: takeMoneyButton.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),

            continieTapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            continieTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continieTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continieTapView.heightAnchor.constraint(equalToConstant: 100),
            
            overallStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            overallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            overallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            overallStackView.bottomAnchor.constraint(equalTo: continieTapView.topAnchor),
        ])
        
        createStacksWithQuestions()
    }
    
    func createViewWithQuestion(questionNumber: Int, moneycount: Int) -> UIView {
        let questionNumberLabel = UILabel()
        questionNumberLabel.text = "Вопрос: \(questionNumber)"
        questionNumberLabel.textColor = .white
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let moneyCountLabel = UILabel()
        moneyCountLabel.text = "\(moneycount) RUB"
        moneyCountLabel.textColor = .white
        moneyCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let viewForQuestion = UIView()
        viewForQuestion.translatesAutoresizingMaskIntoConstraints = false
        viewForQuestion.addSubview(questionNumberLabel)
        viewForQuestion.addSubview(moneyCountLabel)
        
        NSLayoutConstraint.activate([
            questionNumberLabel.leadingAnchor.constraint(equalTo: viewForQuestion.leadingAnchor, constant: 20),
            questionNumberLabel.centerYAnchor.constraint(equalTo: viewForQuestion.centerYAnchor),
            
            moneyCountLabel.trailingAnchor.constraint(equalTo: viewForQuestion.trailingAnchor, constant: -20),
            moneyCountLabel.centerYAnchor.constraint(equalTo: viewForQuestion.centerYAnchor)
        ])
        
        switch questionNumber {
            
        case 5: setBackground(in: viewForQuestion, with: RectangleImages.blue.rawValue)
        case 10: setBackground(in: viewForQuestion, with: RectangleImages.blue.rawValue)
        case 15: setBackground(in: viewForQuestion, with: RectangleImages.yellow.rawValue)

        default:
            viewForQuestion.backgroundColor = .systemPurple
            setBackground(in: viewForQuestion, with: RectangleImages.purple.rawValue)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if questionNumber == self.currentQuestion {
                self.flashingAnimation(in: viewForQuestion)
            }
        }
        
        viewForQuestion.layer.cornerRadius = 16
        
        return viewForQuestion
    }

    
    
    private func setBackground(in view: UIView, with backgroundName: String) {
        let backgroundView = UIImageView(image: UIImage(named: backgroundName))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.sendSubviewToBack(backgroundView)
    }
    
    
    private var animationCounter = 0
    
    private func flashingAnimation(in view: UIView) {
        let backGroundImageView = view.subviews.compactMap ({ view in
            return view as? UIImageView
        })[0]
        
        let flashingBackgroundView: UIImage = self.isCorrect
        ? UIImage(named: RectangleImages.green.rawValue)!
        : UIImage(named: RectangleImages.red.rawValue)!
        
        
        UIView.transition(with: backGroundImageView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { backGroundImageView.image = flashingBackgroundView },
                          completion: { [weak self] _ in
            guard let self = self else { return }
            self.animationCounter += 1
            if self.animationCounter < 3 {
                self.flashingAnimation(in: view)
            }
        })
        
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}



