//
//  File.swift
//  digimon
//
//  Created by Emira Hajj on 5/14/21.
//

import Foundation
import UIKit


extension UIView {

    func createGradientLayer(frame: CGRect, colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.colors = colors
        self.layer.insertSublayer(layer, at: 0)
    }
}

extension SideMenuCell {
    func formatCell(width: CGFloat, height: CGFloat){
        self.labelText = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        self.labelText.adjustsFontSizeToFitWidth = true
        self.labelText.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        self.labelText.font = UIFont(name: "Menlo-Bold", size: 12)
        self.labelText.textColor = UIColor.black
        self.labelText.textAlignment = NSTextAlignment.center
        self.addSubview(self.labelText)
        self.backgroundColor = UIColor.clear
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

extension UILabel {
    
    func formatName() {
        self.text = self.text?.replacingOccurrences(of: "-", with: " ").capitalized
    }
}

extension UIImageView {
    
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, _, error in
            if error == nil, let url = url, let data = try? Data(contentsOf: url), // 3
               let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let weakSelf = self {
                            weakSelf.image = image
                        }
                    }
                }
            }
            downloadTask.resume()
            return downloadTask
    }
}

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}


