import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    // MARK: - IB Outlets
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter:AlertPresenter?
    
    // MARK: - View Life Cycles
    override func viewDidLoad(){
        super.viewDidLoad()
        presenter = MovieQuizPresenter (viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        setUpImageView()
        showLoadingIndicator()
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
    // MARK: - View Configuration
    func setUpImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    // MARK: - UI Updates
    func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    func resetBorder() {
        imageView.layer.borderColor = nil
    }
    // MARK: - Quiz Updates
    func show(quiz step: QuizStepViewModel){
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func show(quiz result: QuizResultViewModel){
        guard let alertPresenter = alertPresenter else {
            return
        }
        let message = presenter.makeResultsMessage()
        let alert = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else{return}
                
                self.presenter.restartGame()
            }
        )
        alertPresenter.displayAlert(model:alert)
    }
    // MARK: - Error Handling
    func showNetworkError(message: String) {
        hideLoadingIndicator ()
        let model = AlertModel(title: "Что-то пошло не так(",
                               message: "Невозможно загрузить данные",
                               buttonText: "Попробовать ещё раз",
                               completion: { [weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            self.showLoadingIndicator()
        })
        alertPresenter?.displayAlert(model: model)
    }
}
