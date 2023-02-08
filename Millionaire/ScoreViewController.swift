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
    
    //    lazy var backgroundView: UIImageView = {
    //        let backgroundView = UIImageView()
    //        backgroundView.translatesAutoresizingMaskIntoConstraints = false
    //        backgroundView.image = UIImage(named: "background")!
    //
    //        return backgroundView
    //    }()
    
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
        
        
        
        createView()
    }
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(currentQuestion: Int, correct: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.currentQuestion = currentQuestion
        self.isCorrect = correct
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkForLoose(currentQuestion: currentQuestion)
    }
    
    
    @objc func didTapContiniueView() {
        navigationController?.popViewController(animated: false)
    }
    
    private func createStacksWithQuestions() {
        stride(from: 15, to: 0, by: -1) .forEach { num in
            overallStackView.addArrangedSubview(createViewWithQuestion(questionNumber: num, moneycount: num * 100))
        }
    }
    
    private func checkForLoose(currentQuestion: Int) {
        if !isCorrect {
            switch currentQuestion {
            case 1...5:
                presentDefaultError(title: "Вы проиграли", text: "Проиграли..")
            case 6...10:
                presentDefaultError(title: "Вы проиграли", text: "Забираете 1000 рублей")
            case 11...15:
                presentDefaultError(title: "Вы проиграли", text: "Забираете 33000 рублей")
            default: assertionFailure("only 15 questions")
            }
        }
    }

    private func presentDefaultError(title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)

    }
    
    private func createView() {
        setBackground(in: view, with: "background")
        
        view.addSubview(overallStackView)
        view.addSubview(continieTapView)
        
        NSLayoutConstraint.activate([
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
            
        case 5: viewForQuestion.backgroundColor = .systemBlue
            setBackground(in: viewForQuestion, with: "RectangleBlue")
        case 10: viewForQuestion.backgroundColor = .systemBlue
            setBackground(in: viewForQuestion, with: "RectangleBlue")
        case 15:
            setBackground(in: viewForQuestion, with: "RectangleYellow")
            viewForQuestion.backgroundColor = .systemYellow
        default:
            viewForQuestion.backgroundColor = .systemPurple
            setBackground(in: viewForQuestion, with: "RectanglePurple")
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
        
        let currentImageBackground = backGroundImageView.image
        let flashingBackgroundView: UIImage = self.isCorrect ? UIImage(named: "RectangleGreen")! : UIImage(named: "RectangleRed")!
        
        
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
}



