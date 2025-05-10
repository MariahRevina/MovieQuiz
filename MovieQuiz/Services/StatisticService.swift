import UIKit

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount, bestGameCorrect, bestGameTotal, bestGameDate, totalCorrectAnswers, totalQuestionAsked
    }
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    var totalQuestionAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionAsked.rawValue)
        }
    }
    var totalAccuracy: Double {
        guard totalCorrectAnswers > 0 else { return 0 }
        return (Double(totalCorrectAnswers)/(Double(totalQuestionAsked)))*100
    }
    func store(gameResult: GameResult) {
        totalQuestionAsked += gameResult.total
        totalCorrectAnswers += gameResult.correct
        gamesCount += 1
        if gameResult.compare(result: bestGame) {
            bestGame = gameResult
        }
        storage.synchronize()
    }
}
