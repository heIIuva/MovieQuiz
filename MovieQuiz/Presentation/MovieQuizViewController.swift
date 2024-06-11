import UIKit


// API k_zcuw1ytf


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var questionTitlelabel: UILabel!
    @IBOutlet private weak var indexlabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel! {
        didSet {
            self.questionLabel.lineBreakMode = .byWordWrapping
            self.questionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet private weak var movieImage: UIImageView!
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        givenAnswer(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        givenAnswer(false)
    }
    
    private let questionsAmount: Int = 10
    
    private var currentQuestion: QuizQuestion?

    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitlelabel.font = UIFont.ysDisplayMedium
        indexlabel.font = UIFont.ysDisplayMedium
        questionLabel.font = UIFont.ysDisplayBold
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        let statisticService = StatisticService()
        statisticService.delegate = self
        self.statisticService = statisticService
        
        showLoadingIndicator()
        questionFactory.loadData()
        
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func failedToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.color = .ypBlack
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let completion = { [weak self] in
            guard let self else { return }
            currentQuestionIndex = 0
            correctAnswers = 0
            self.questionFactory?.loadData()
            //self.questionFactory?.requestNextQuestion()
        }
        
        let viewModel = AlertModel(title: "Error",
                                   message: message,
                                   buttonText: "try again",
                                   completion: completion)
        
        alertPresenter?.showAlert(result: viewModel)
    }
    
    private func givenAnswer(_ givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        disableButtons()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        indexlabel.text = step.questionNumber
        questionLabel.text = step.question
        movieImage.image = step.image
        movieImage.layer.cornerRadius = 20
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        movieImage.layer.masksToBounds = true
        movieImage.layer.borderWidth = 8
        movieImage.layer.cornerRadius = 20
        movieImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.movieImage.layer.borderColor = UIColor.ypBlack.cgColor
            self.showNextQuestionOrResults()
            self.enableButtons()
        }
    }
    
    private func showNextQuestionOrResults() {
        guard let questionFactory else { return }
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            let date = Date()
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount, date: date)
            
            let alertText = """
                            Your result: \(correctAnswers)/10
                            Rounds played: \(statisticService?.gamesCount ?? 0)
                            Best result: \(statisticService?.bestGame.correct ?? 0)/10 on \(statisticService?.bestGame.date.dateTimeString ?? "")
                            Average accuracy: \(String(format: "%.2f", statisticService?.totalAccuracy ?? ""))%
                            """
            let completion = { [weak self] in
                guard let self else { return }
                currentQuestionIndex = 0
                correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            
            let viewModel = AlertModel(
                title: "The round is over",
                message: alertText,
                buttonText: "play again",
                completion: completion)
            
            alertPresenter?.showAlert(result: viewModel)
            
        } else {
            
            currentQuestionIndex += 1
            
            questionFactory.requestNextQuestion()
            
        }
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
}

