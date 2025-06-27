import UIKit

final class MovieQuizPresenter {
    var alertPresenter:AlertPresenter?
     var correctAnswers: Int = .zero
    
    var questionFactory: QuestionFactoryProtocol?

    var statisticService: StatisticServiceProtocol?
    
    var currentQuestion:QuizQuestion?
    
    weak var viewController: MovieQuizViewController?

    let questionsAmount: Int = 10
    private var currentQuestionIndex:Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage (data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
     func yesButtonClicked() {
         didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else {return}
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        viewController?.changeStateButton(isEnabled: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question else{
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async{[weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        viewController?.changeStateButton(isEnabled: true)
        viewController?.resetBorder()
        
        if self.isLastQuestion() {
            /* guard let statisticService = statisticService else {return}
            
            let gameResult = GameResult(correct: correctAnswers, total: questionsAmount, date: Date())
            
            statisticService.store(gameResult: gameResult)
            
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let totalAccuracy = statisticService.totalAccuracy
            let date = bestGame.date.dateTimeString
            
            let text = "Ваш результат: \(correctAnswers)/\(self.questionsAmount)\n Количество сыгранных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(date)) \n Средняя точность: \(String (format: "%.2f", totalAccuracy))%" */
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultViewModel (
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else{
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
