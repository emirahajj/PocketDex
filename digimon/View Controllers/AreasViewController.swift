//
//  AreasViewController.swift
//  digimon
//
//  Created by Emira Hajj on 4/27/21.
//

import UIKit

class AreasViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regionName: UILabel!
    let segControl = UISegmentedControl()

    
    var imageArray : [UIImage] = [UIImage(named: "kanto.png")!, UIImage(named: "johto.png")!, UIImage(named: "hoenn.png")!, UIImage(named: "sinnoh.png")!, UIImage(named: "unova.png")!]
    
    let nameArray = ["kanto", "johto", "hoenn", "sinnoh", "unova"]
    
    var areas = [cellData]()
    var subcategories : [String] = []

    

    
    //put in a single view that will hold everything inside the scrollview and add the imageViews to that view
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let contentHeight = scrollView.bounds.height
        let contentWidth = scrollView.bounds.width * 5
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
//        scrollView.backgroundColor = UIColor.red
//
        var offset = CGFloat(0)
        let subviewWidth = CGFloat(view.bounds.width)

        for index in 0..<imageArray.count {
            segControl.insertSegment(withTitle: nameArray[index], at: index, animated: false)
            let frame = CGRect(x: offset, y: 0, width: view.bounds.width, height: 300)
            
            let imgGradient = CAGradientLayer()
            imgGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
            let customColor = UIColor(red: 0.24, green: 0.25, blue: 0.37, alpha: 1.00)
            
            imgGradient.colors = [UIColor.clear.cgColor, customColor.cgColor]
            imgGradient.locations = [0, 0.9]
            
            
            let iView = UIImageView(frame: frame)
            iView.image = imageArray[index]
            iView.clipsToBounds = true
            iView.contentMode = .scaleToFill
            iView.layer.insertSublayer(imgGradient, at: 0)
            scrollView.addSubview(iView)

            offset += subviewWidth
        }
        print(segControl.numberOfSegments)
        segControl.selectedSegmentIndex = 0
        regionName.text = nameArray[segControl.selectedSegmentIndex]
        
        //API call now
        
        let url = URL(string: "https://pokeapi.co/api/v2/region/\(nameArray[segControl.selectedSegmentIndex])")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let locations = dataDictionary["locations"] as! [[String:Any]]
                var cellDataLocations : [cellData] = []
                for location in locations {
                    let newCellData = cellData(opened: false, title: location["name"] as! String, sectionData: [])
                    cellDataLocations.append(newCellData)
                }
                
                self.areas = cellDataLocations
                
                for subCategory in self.subcategories {
                    let newSub = cellData(opened: false, title: subCategory, sectionData: [])
                    self.areas.append(newSub)
                }
                self.tableView.reloadData()


            }
        }

        task.resume()


        // Do any additional setup after loading the view.
    }
    
    
    func formatName(string : String) -> String {
        let newString = string.replacingOccurrences(of: "-", with: " ")
        return newString.capitalized
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if areas[section].opened {
            return areas[section].sectionData.count + 1
        } else {
            return 1
        }    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainAreaCell") as! MainAreaCell
            cell.backgroundColor = UIColor(red: 0.24, green: 0.25, blue: 0.37, alpha: 1.00)
            cell.areaName?.text = formatName(string: areas[indexPath.section].title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainAreaCell") as! MainAreaCell
//            cell.areaName?.text = areas[indexPath.section].title
            return cell

        }

    }

    @IBAction func onLeftSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex < 4 {
            segControl.selectedSegmentIndex += 1
            regionName.text = nameArray[segControl.selectedSegmentIndex]
            let newOffset = CGPoint(x: scrollView.contentOffset.x + view.frame.width, y: scrollView.contentOffset.y)
            scrollView.setContentOffset(newOffset, animated: true)
        }

    }
    
    
    @IBAction func onRightSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex > 0 {
            segControl.selectedSegmentIndex -= 1
            let newOffset = CGPoint(x: scrollView.contentOffset.x - (view.frame.width), y: scrollView.contentOffset.y)
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
