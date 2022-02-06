//
//  DataSettings.swift
//  VK Project
//
//  Created by Антон Титов on 07.02.2022.
//

import UIKit

class DataSettings {
    
    func setupUser() -> [User] {
        
        var resultArray = [User]()
        
        let userOnePhotoArray = [UIImage(named: "1_1")!, UIImage(named: "1_2")!, UIImage(named: "1_3")!, UIImage(named: "1_4")!]
        let userOne = User(name: "Shibkov Roman", avatar: UIImage(named: "1_1")!, photoArray: userOnePhotoArray)
        
        resultArray.append(userOne)
        
        let userTwoPhotoArray = [UIImage(named: "2_1")!, UIImage(named: "2_2")!, UIImage(named: "2_3")!, UIImage(named: "2_4")!]
        let userTwo = User(name: "Modin Alex", avatar: UIImage(named: "2_1")!, photoArray: userTwoPhotoArray)
        
        resultArray.append(userTwo)
        
        let userThreePhotoArray = [UIImage(named: "3_1")!, UIImage(named: "3_2")!, UIImage(named: "3_3")!, UIImage(named: "3_4")!]
        let userThree = User(name: "Sycheskiy Alex", avatar: UIImage(named: "3_1")!, photoArray: userThreePhotoArray)
        
        resultArray.append(userThree)
        
        let userFourPhotoArray = [UIImage(named: "4_1")!, UIImage(named: "4_2")!, UIImage(named: "4_3")!, UIImage(named: "4_4")!]
        let userFour = User(name: "Kuznetsov Ivan", avatar: UIImage(named: "4_1")!, photoArray: userFourPhotoArray)
        
        resultArray.append(userFour)
        
        let sortiredNames = resultArray.sorted(by: {$0.name < $1.name})
        
        resultArray = sortiredNames
        
        return resultArray
    }
    
    func setupGroup() -> [Group] {
        
        var resultArray = [Group]()
        
        let globalGroupOne = Group(name: "FunGroup Ronaldo", avatar: UIImage(named: "1_3")!, description: nil)
        resultArray.append(globalGroupOne)
        
        let globalGroupTwo = Group(name: "FunGroup Beckham", avatar: UIImage(named: "2_2")!, description: nil)
        resultArray.append(globalGroupTwo)
        
        let globalGroupThree = Group(name: "FunGroup Messi", avatar: UIImage(named: "4_4")!, description: nil)
        resultArray.append(globalGroupThree)
        
        let globalGroupFour = Group(name: "FunGroup Ronaldinho", avatar: UIImage(named: "3_3")!, description: nil)
        resultArray.append(globalGroupFour)
        
        return resultArray
    }
    
    func setupNews() -> [News] {
        
        var resultArray = [News]()
        
        let newsOne = News(newsText: "«ПСЖ» – «МЮ», «АТЛЕТИКО» – «БАВАРИЯ». ИТОГИ ЖЕРЕБЬЕВКИ 1/8 ЛИГИ ЧЕМПИОНОВ УЕФА, КОТОРУЮ ПЕРЕИГРАЮТ! Манипуляции с шариками провел Андрей Аршавин – посол финала турнира, который в этом сезоне пройдет в Санкт-Петербурге.", newsImage: UIImage(named: "news_1"), numberOfViews: 116)
        
        resultArray.append(newsOne)
        
        let newsTwo = News(newsText: "Большой скандал на жеребьевки 1/8 Финала ЛЧ УЕФА 2020/2021 года. Что происходит в УЕФА? Во всём виновата Россия?", newsImage: UIImage(named: "news_2"), numberOfViews: 142)
        
        resultArray.append(newsTwo)
        
        let newsThree = News(newsText: "«Возможно, нам следует меньше зависеть от технологий» — президент УЕФА об ошибке при жеребьевке плей-офф Лиги чемпионов", newsImage: nil, numberOfViews: 166)
        
        resultArray.append(newsThree)
        
        let newsFour = News(newsText: "В УЕФА принято решение о проведение повторной жеребьевки из-за технической ошибки! 🤷‍♂️", newsImage: UIImage(named: "news_3"), numberOfViews: 99)
        resultArray.append(newsFour)
        
        return resultArray
    }
}
