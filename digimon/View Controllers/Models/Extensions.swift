//
//  File.swift
//  digimon
//
//  Created by Emira Hajj on 5/14/21.
//

import Foundation
import UIKit


extension UIView {

    func addGradient(frame: CGRect) {
        let blue = UIColor(red: 0.62, green: 0.28, blue: 0.76, alpha: 1.00).cgColor
        let green = UIColor(red: 0.27, green: 0.64, blue: 0.84, alpha: 1.00).cgColor
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.colors = [blue, green]
        self.layer.insertSublayer(layer, at: 0)
    }
}

extension UIProgressView{

    override open func awakeFromNib() {
        super.awakeFromNib()
        changeStyles()
    }
    func changeStyles(){
        self.transform = CGAffineTransform(scaleX: 1, y: 2)
        self.layer.cornerRadius = 5
        self.layer.sublayers![1].cornerRadius = 5
        self.clipsToBounds = true
        self.subviews[1].clipsToBounds = true
        self.trackTintColor = UIColor.darkGray.withAlphaComponent(0.4)
    }
}

extension UIButton {
    func buttonStyle(_ a : String){
        let capType = a.prefix(1).uppercased() + a.lowercased().dropFirst()
        self.titleLabel?.text = capType
        self.setTitle(capType, for: .normal)
        
        self.backgroundColor = dict.init().typeColors[a]
        self.layer.cornerRadius = 8
        self.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        self.titleLabel?.layer.shadowOffset = CGSize(width: -0.15, height: 0.5)
        self.titleLabel!.layer.shadowOpacity = 1.0
    }
}

