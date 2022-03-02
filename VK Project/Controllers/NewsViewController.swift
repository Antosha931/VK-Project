//
//  NewsViewController.swift
//  VK Project
//
//  Created by Антон Титов on 31.01.2022.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    
    private let reuseIdentifier = "NewsCell"
    
    private var newsArray = [News]()
    
    private func setupNews() -> [News] {
        
        var resultArray = [News]()
        
        let newsOne = News(newsText: "«ПСЖ» – «МЮ», «АТЛЕТИКО» – «БАВАРИЯ». ИТОГИ ЖЕРЕБЬЕВКИ 1/8 ЛИГИ ЧЕМПИОНОВ УЕФА, КОТОРУЮ ПЕРЕИГРАЮТ! Манипуляции с шариками провел Андрей Аршавин – посол финала турнира, который в этом сезоне пройдет в Санкт-Петербурге.", newsImage: UIImage(named: "news_1"), numberOfViews: 112)
        
        resultArray.append(newsOne)
        
        let newsTwo = News(newsText: "Большой скандал на жеребьевки 1/8 Финала ЛЧ УЕФА 2020/2021 года. Что происходит в УЕФА? Во всём виновата Россия?", newsImage: UIImage(named: "news_2"), numberOfViews:87)
        
        resultArray.append(newsTwo)
        
        let newsThree = News(newsText: "«Возможно, нам следует меньше зависеть от технологий» — президент УЕФА об ошибке при жеребьевке плей-офф Лиги чемпионов", newsImage: nil, numberOfViews: 16)
        
        resultArray.append(newsThree)
        
        let newsFour = News(newsText: "В УЕФА принято решение о проведение повторной жеребьевки из-за технической ошибки! 🤷‍♂️", newsImage: UIImage(named: "news_3"), numberOfViews: 44)
        
        resultArray.append(newsFour)
        
        return resultArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        newsArray = setupNews()
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                as? NewsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(news: newsArray[indexPath.item])
        
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
}
