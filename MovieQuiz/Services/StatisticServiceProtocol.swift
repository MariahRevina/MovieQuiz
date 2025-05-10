import UIKit

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // кол-во заверш игр
    var bestGame: GameResult { get } // инфо о лучшей попытке
    var totalAccuracy: Double { get } // сред точность правильных ответов за все игры в процентах
    func store(gameResult: GameResult)
}
