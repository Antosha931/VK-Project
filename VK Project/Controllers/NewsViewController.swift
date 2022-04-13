//
//  NewsViewController.swift
//  VK Project
//
//  Created by Антон Титов on 31.01.2022.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView! {
        didSet {
            self.newsTableView.dataSource = self
            self.newsTableView.delegate = self
        }
    }
    
    private var newsArray = [News]()
    
    private func setupNews() -> [News] {
        
        var resultArray = [News]()
        
        let newsOne = News(authorName: "UEFA", authorAvatar: UIImage(named: "avatar")!, dateNews: Date(), textNews: "«ПСЖ» – «МЮ», «АТЛЕТИКО» – «БАВАРИЯ». ИТОГИ ЖЕРЕБЬЕВКИ 1/8 ЛИГИ ЧЕМПИОНОВ УЕФА, КОТОРУЮ ПЕРЕИГРАЮТ! Манипуляции с шариками провел Андрей Аршавин – посол финала турнира, который в этом сезоне пройдет в Санкт-Петербурге.", imageNews: UIImage(named: "news_1"), numbersViews: 112)
        
        resultArray.append(newsOne)
        
        let newsTwo = News(authorName: "UEFA", authorAvatar: UIImage(named: "avatar")!, dateNews: Date(), textNews: "Большой скандал на жеребьевки 1/8 Финала ЛЧ УЕФА 2020/2021 года. Что происходит в УЕФА? Во всём виновата Россия?", imageNews:  UIImage(named: "news_2"), numbersViews: 87)
        
        resultArray.append(newsTwo)
        
        let newsThree = News(authorName: "UEFA", authorAvatar: UIImage(named: "avatar")!, dateNews: Date(), textNews: "«Возможно, нам следует меньше зависеть от технологий» — президент УЕФА об ошибке при жеребьевке плей-офф Лиги чемпионов", imageNews: nil, numbersViews: 87)
        
        resultArray.append(newsThree)
        
        let newsFour = News(authorName: "UEFA", authorAvatar: UIImage(named: "avatar")!, dateNews: Date(), textNews: "В УЕФА принято решение о проведение повторной жеребьевки из-за технической ошибки! 🤷‍♂️", imageNews: UIImage(named: "news_3"), numbersViews: 44)
        
        resultArray.append(newsFour)
        
        return resultArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        newsTableView.register(UINib(nibName: "AuthorNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthorCell")
        newsTableView.register(UINib(nibName: "TextNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        newsTableView.register(UINib(nibName: "ImageNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        newsTableView.register(UINib(nibName: "InfoPanelTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        
        newsArray = setupNews()
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        newsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath) as? AuthorNewsTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(author: newsArray[indexPath.section])
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextNewsTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(news: newsArray[indexPath.section])
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageNewsTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(image: newsArray[indexPath.section])
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoPanelTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(news: newsArray[indexPath.section])
            
            return cell
          
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 3:
            return 50
        default:
            return UITableView.automaticDimension
        }
    }
}
