import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(alert: UIAlertController)
}
