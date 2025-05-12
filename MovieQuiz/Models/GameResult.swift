import UIKit

struct GameResult {
    let correct: Int // кол-во прав ответов
    let total: Int // кол-во вопросов квиза
    let date: Date // ну тут понятно
    
    func compare (result: GameResult) -> Bool {
        correct > result.correct
        }
    }

