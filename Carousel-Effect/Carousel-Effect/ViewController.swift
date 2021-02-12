//
//  ViewController.swift
//  Carousel-Effect
//
//  Created by Danda, Dinesh on 2/12/21.
//  Copyright © 2021 Danda, Dinesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let trasnformLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        panGestureSetup()
        setupTransfromLayer()
        flippingCarousel()
        imagesInFlow()
    }
    
    func degreeToRadians(degree: CGFloat) -> CGFloat {
        return (degree * CGFloat.pi) / 180
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    internal func imagesInFlow() {
        for i in 1...6 {
            addImageCard(imageName: "dog\(i)")
        }
    }
    
    internal func panGestureSetup() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.performPanAction(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    internal func setupTransfromLayer() {
        trasnformLayer.frame = self.view.bounds
        view.layer.addSublayer(trasnformLayer)
    }
    
    internal func addImageCard(imageName: String) {
        let imageCardSize = CGSize(width: 200, height: 300)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2, y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        guard let imageCardImage = UIImage(named: imageName)?.cgImage else { return }
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        imageLayer.cornerRadius = 10
        imageLayer.borderWidth = 5
        imageLayer.isDoubleSided = true
        trasnformLayer.addSublayer(imageLayer)
    }
    
    internal func flippingCarousel() {
        guard let transformSublayers = trasnformLayer.sublayers else { return }
        let segmentForImageCard = CGFloat(360 / transformSublayers.count)
        var angleOffset = currentAngle
        for layer in transformSublayers {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(transform, degreeToRadians(degree: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            layer.transform = transform
            angleOffset += segmentForImageCard
        }
    }
    
    @objc
    func performPanAction(recognizer: UIPanGestureRecognizer) {
        let xOffset = recognizer.translation(in: self.view).x
        if recognizer.state == .began {
            currentOffset = 0
        }
        let xDiff = xOffset  * 0.6 - currentOffset
        currentOffset += xDiff
        currentAngle += xDiff
        flippingCarousel()
    }
}

