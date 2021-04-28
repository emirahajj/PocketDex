//
//  AreasViewController.swift
//  digimon
//
//  Created by Emira Hajj on 4/27/21.
//

import UIKit

class AreasViewController: UIViewController, UIScrollViewDelegate {
    
    var imageArray : [UIImage] = [UIImage(named: "kanto.png")!, UIImage(named: "johto.png")!, UIImage(named: "hoenn.png")!, UIImage(named: "sinnoh.png")!, UIImage(named: "unova.png")!]
    
    let nameArray = ["Kanto", "Johto", "Hoenn", "Sinnoh", "Unova"]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var regionName: UILabel!
    //strategy:
    //make scroll view not user touch enabled
    //make the whole view controller have left and right swipe gestures
    //invisible segmented control to toggle between regions like previous VC
    let segControl = UISegmentedControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentHeight = scrollView.bounds.height
        let contentWidth = scrollView.bounds.width * 5
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
//        scrollView.backgroundColor = UIColor.red
//
        var offset = CGFloat(0)
        let subviewWidth = CGFloat(view.bounds.width + 100)

        
        
        for index in 0..<imageArray.count {
            segControl.insertSegment(withTitle: nameArray[index], at: index, animated: false)
            let frame = CGRect(x: offset, y: 0, width: view.bounds.width, height: 300)
            let iView = UIImageView(frame: frame)
            iView.image = imageArray[index]
            iView.clipsToBounds = true
            iView.contentMode = .scaleToFill
            scrollView.addSubview(iView)
            offset += subviewWidth
        }
        segControl.selectedSegmentIndex = 0
        print(segControl.numberOfSegments)

        
        regionName.text = nameArray[segControl.selectedSegmentIndex]

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onLeftSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex < 4 {
            segControl.selectedSegmentIndex += 1
            regionName.text = nameArray[segControl.selectedSegmentIndex]
            let newOffset = CGPoint(x: scrollView.contentOffset.x + view.frame.width + 100, y: scrollView.contentOffset.y)
            scrollView.setContentOffset(newOffset, animated: true)
        }

    }
    
    
    @IBAction func onRightSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex > 0 {
            segControl.selectedSegmentIndex -= 1
            let newOffset = CGPoint(x: scrollView.contentOffset.x - (view.frame.width + 100), y: scrollView.contentOffset.y)
            scrollView.setContentOffset(newOffset, animated: true)
        }
        regionName.text = nameArray[segControl.selectedSegmentIndex]


    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
