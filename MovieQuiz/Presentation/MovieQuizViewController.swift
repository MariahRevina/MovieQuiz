import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate,AlertPresenterDelegate {
    // MARK: - IB Outlets
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Private Properties
    private let presenter = MovieQuizPresenter()
    private var correctAnswers: Int = .zero
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter:AlertPresenter?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad(){
        super.viewDidLoad()
        
        presenter.viewController = self
        setUpImageView()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
    }
    
    // MARK: - QuestionFactoryDelegate
   func didReceiveNextQuestion(question: QuizQuestion?){
       presenter.didReceiveNextQuestion(question: question)
        }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - AlertPresenterDelegate
    func present(alert: UIAlertController){
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    // MARK: - Private Methods
    
    private func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator ()
        
        let model = AlertModel(title: "Что-то пошло не так(",
                               message: "Невозможно загрузить данные",
                               buttonText: "Попробовать ещё раз",
                               completion: { [weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.showLoadingIndicator()
            self.questionFactory?.loadData()
        })
        alertPresenter?.displayAlert(model: model)
    }
    
    func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func setUpImageView(){
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    func show(quiz result: QuizResultViewModel){
        guard let alertPresenter = alertPresenter else {
            return
        }
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else{return}
                
                presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter.displayAlert(model:alert)
    }
    
     func showAnswerResult(isCorrect:Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else {return}
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.setUpImageView()
        }
    }
    func resetBorder() {
        imageView.layer.borderColor = nil
    }
    /* private func showNextQuestionOrResults(){
        changeStateButton(isEnabled: true)
        if presenter.isLastQuestion() {
            guard let statisticService = statisticService else {return}
            
            let gameResult = GameResult(correct: correctAnswers, total: presenter.questionsAmount, date: Date())
            
            statisticService.store(gameResult: gameResult)
            
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let totalAccuracy = statisticService.totalAccuracy
            let date = bestGame.date.dateTimeString
            
            let text = "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\n Количество сыгранных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(date)) \n Средняя точность: \(String (format: "%.2f", totalAccuracy))%"
            
            let viewModel = QuizResultViewModel (
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else{
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    } */
    func changeStateButton(isEnabled: Bool) {
       noButton.isEnabled = isEnabled
       yesButton.isEnabled = isEnabled
   }
}
