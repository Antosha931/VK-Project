//
//  GalleryPhotoCustomView.swift
//  VK Project
//
//  Created by Антон Титов on 05.02.2022.
//

import UIKit

class GalleryPhotoCustomView: UIView {
    
    private var view: UIView?
    
    private var interactiveAnimator: UIViewPropertyAnimator!
    
    private var firstImageView = UIImageView()
    private var secondaryImageView = UIImageView()
    private var images = [UIImage]()
    private var isLeftSwipe = false
    private var isRightSwipe = false
    private var chooseFlag = false
    private var currentIndex = Int()
    private var customPageView = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GalleryPhotoCustomView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    private func setup() {
        view = loadFromNib()
        guard let view = view else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .lightGray
        addSubview(view)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(recognizer)

        firstImageView.frame = self.bounds
        firstImageView.backgroundColor = .lightGray
        addSubview(firstImageView)

        secondaryImageView.frame = self.bounds
        secondaryImageView.backgroundColor = .lightGray
        secondaryImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        addSubview(secondaryImageView)
        
        customPageView.backgroundColor = UIColor.clear
        customPageView.frame = CGRect(x: 1, y: 1, width: 150, height: 50)
        customPageView.layer.zPosition = 100
        customPageView.numberOfPages = 1
        customPageView.currentPage = 0
        customPageView.pageIndicatorTintColor = UIColor.lightGray
        customPageView.currentPageIndicatorTintColor = UIColor.black
        addSubview(customPageView)
        customPageView.translatesAutoresizingMaskIntoConstraints = false
        customPageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        customPageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.height / 15).isActive = true
    }
    
    private func onChange(isLeft: Bool) {
        self.firstImageView.transform = .identity
        self.secondaryImageView.transform = .identity
        self.firstImageView.image = images[currentIndex]
        
        if isLeft {
            self.secondaryImageView.image = images[self.currentIndex + 1]
            self.secondaryImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }
        else {
            self.secondaryImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            self.secondaryImageView.image = images[currentIndex - 1]
        }
    }
    
    private func onChangeCompletion(isLeft: Bool) {
        self.firstImageView.transform = .identity
        self.secondaryImageView.transform = .identity
        if isLeft {
            self.currentIndex += 1
        }
        else {
            self.currentIndex -= 1
        }
        self.firstImageView.image = self.images[self.currentIndex]
        self.bringSubviewToFront(self.firstImageView)
        self.customPageView.currentPage = self.currentIndex
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        if let animator = interactiveAnimator,
           animator.isRunning {
            return
        }
        
        switch recognizer.state {
        case .began:
            self.firstImageView.transform = .identity
            self.firstImageView.image = images[currentIndex]
            self.secondaryImageView.transform = .identity
            self.bringSubviewToFront(self.firstImageView)
            
            interactiveAnimator?.startAnimation()
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         curve: .easeInOut,
                                                         animations: { [weak self] in
                                                            self?.firstImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                                                         })
            interactiveAnimator.pauseAnimation()
            isLeftSwipe = false
            isRightSwipe = false
            chooseFlag = false
        case .changed:
            var translation = recognizer.translation(in: self.view)
            
            if translation.x < 0 && (!isLeftSwipe) && (!chooseFlag) {
                if self.currentIndex == (images.count - 1) {
                    interactiveAnimator.stopAnimation(true)
                    return
                }
                chooseFlag = true
                onChange(isLeft: true)
                
                interactiveAnimator.stopAnimation(true)
                interactiveAnimator.addAnimations { [weak self] in
                    self?.firstImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    self?.secondaryImageView.transform = .identity
                }
                interactiveAnimator.addCompletion({ [weak self] _ in
                    self?.onChangeCompletion(isLeft: true)
                })
                
                interactiveAnimator.startAnimation()
                interactiveAnimator.pauseAnimation()
                isLeftSwipe = true
            }
            
            if translation.x > 0 && (!isRightSwipe) && (!chooseFlag) {
                if self.currentIndex == 0 {
                    interactiveAnimator.stopAnimation(true)
                    return
                }
                chooseFlag = true
                onChange(isLeft: false)
                interactiveAnimator.stopAnimation(true)
                interactiveAnimator.addAnimations { [weak self] in
                    self?.firstImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    self?.secondaryImageView.transform = .identity
                }
                interactiveAnimator.addCompletion({ [weak self] _ in
                    self?.onChangeCompletion(isLeft: false)
                })
                interactiveAnimator.startAnimation()
                interactiveAnimator.pauseAnimation()
                isRightSwipe = true
            }
            
            if isRightSwipe && (translation.x < 0) {return}
            if isLeftSwipe && (translation.x > 0) {return}
            
            if translation.x < 0 {
                translation.x = -translation.x
            }
            interactiveAnimator.fractionComplete = translation.x / (UIScreen.main.bounds.width)
            
        case .ended:
            if let animator = interactiveAnimator,
               animator.isRunning {
                return
            }
            var translation = recognizer.translation(in: self.view)
            
            if translation.x < 0 {translation.x = -translation.x}
            
            if (translation.x / (UIScreen.main.bounds.width)) > 0.5  {
                interactiveAnimator.startAnimation()
            }
            else {
                interactiveAnimator.stopAnimation(true)
                interactiveAnimator.finishAnimation(at: .start)
                interactiveAnimator.addAnimations { [weak self] in
                    self?.firstImageView.transform = .identity
                    guard let weakSelf = self else {return}
                    if weakSelf.isLeftSwipe {
                        self?.secondaryImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    }
                    if weakSelf.isRightSwipe {
                        self?.secondaryImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    }
                }
                
                interactiveAnimator.addCompletion({ [weak self] _ in
                    self?.firstImageView.transform = .identity
                    self?.secondaryImageView.transform = .identity
                })
                
                interactiveAnimator.startAnimation()
            }
        default:
            return
        }
    }
    
    
    func setImages(images: [UIImage], index: Int) {
        self.images = images
        self.currentIndex = index
        if self.images.count > 0 {
            self.firstImageView.image = self.images[index]
        }
        customPageView.numberOfPages = self.images.count
        customPageView.currentPage = index
    }
}
