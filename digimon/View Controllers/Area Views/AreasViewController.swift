//
//  AreasViewController.swift
//  digimon
//
//  Created by Emira Hajj on 4/27/21.
//

import UIKit

extension UIView {
    
}

class AreasViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regionName: UILabel!
    
    let segControl = UISegmentedControl()
    let defaults = UserDefaults.standard
    
    var imageArray = [UIImage]()
    
    var nameArray = [String]()
    
    var areas = [cellData]()
    var subcategories : [String] = []
    
        
    //utilizing viewDidAppear so that the content refreshes when the user goes back to change the game version
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        segControl.removeAllSegments()
        
        
        let gameVersion = defaults.object(forKey: "versionGroup") as! String
        nameArray = dict.init().versionGroupLocationLookup[gameVersion]!
        imageArray = nameArray.map { UIImage(named: "\($0).png")!}
        
        

        view.addGradient(frame: view.frame)
        
        let contentHeight = scrollView.bounds.height
        let contentWidth = scrollView.bounds.width * CGFloat(imageArray.count)
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
            imgGradient.frame = scrollView.bounds
            let customColor = UIColor(red: 0.24, green: 0.25, blue: 0.37, alpha: 1.00)
            
            imgGradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
            imgGradient.locations = [0, 0.9]
            
            
            let iView = UIImageView(frame: frame)
            iView.image = imageArray[index]
            iView.clipsToBounds = true
            iView.contentMode = .scaleToFill
            iView.backgroundColor = UIColor.clear
            iView.layer.mask = imgGradient
            scrollView.addSubview(iView)
            offset += subviewWidth
        }
        print(segControl.numberOfSegments)
        segControl.selectedSegmentIndex = 0
        regionName.text = nameArray[segControl.selectedSegmentIndex].capitalized
        
        //API call now
        
        self.fetchAreas(self)


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
            //cell.backgroundColor = UIColor(red: 0.24, green: 0.25, blue: 0.37, alpha: 1.00)
            cell.areaName?.text = formatName(string: areas[indexPath.section].title)
            return cell
        } else { //this is one of the inner location cells
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnterAreaCell") as! InnterAreaCell
            cell.innerAreaName.text = formatName(string: areas[indexPath.section].sectionData[indexPath.row - 1])
            cell.id = areas[indexPath.section].sectionData[indexPath.row - 1]
            return cell

        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //these are the title rows
            if areas[indexPath.section].opened == true { //if its open, close it
                //if it's open, when its clicked, the inner ones go away
                areas[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else { //if it's closed, make the API call and populate new cells with that response
                areas[indexPath.section].opened = true
                
                let sections = IndexSet.init(integer: indexPath.section)
                
                
                let url = URL(string: "https://pokeapi.co/api/v2/location/\(areas[indexPath.section].title)")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        //tableviewdata[indexpath.section].sectionData = [our new aray]
                        let categorieObjects = dataDictionary["areas"] as! [[String:Any]]
                        var categoryNames: [String] = []
                        if categorieObjects.count == 0 {
                            categoryNames.append("Sorry, no pokemon in this area!")
                        } else {
                            for category in categorieObjects {
    //                             let innerSection = innerData(opened: false, title: category["name"] as! String, sectionData: [])
                                categoryNames.append(category["name"] as! String)
                            }
                        }

                        self.areas[indexPath.section].sectionData = categoryNames
                        self.tableView.reloadSections(sections, with: .automatic)
                    }
                }
                

                task.resume()
            }
            
        } else { //this is a row you can click on to bring you to the area VC
            
        }
    }
    
    func fetchAreas(_ sender: Any) {
        
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
                
                self.areas = cellDataLocations.sorted {$0.title < $1.title }
                //self.areas = self.areas.sorted {$0.title < $1.title }
                
                for subCategory in self.subcategories {
                    let newSub = cellData(opened: false, title: subCategory, sectionData: [])
                    self.areas.append(newSub)
                }
                self.tableView.reloadData()


            }
        }

        task.resume()

        
    }
    
    //only applicable for game versions where the user can explore two regions
    //i.e. gold/silver/crystal/heartgold/soulsilver
    @IBAction func onLeftSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex < imageArray.count - 1 {
            segControl.selectedSegmentIndex += 1
            regionName.text = nameArray[segControl.selectedSegmentIndex].capitalized
            let newOffset = CGPoint(x: scrollView.contentOffset.x + view.frame.width, y: scrollView.contentOffset.y)
            scrollView.setContentOffset(newOffset, animated: true)
        }
        self.fetchAreas(self)
    }
    
    //only applicable for game versions where the user can explore two regions
    //i.e. gold/silver/crystal/heartgold/soulsilver
    @IBAction func onRightSwipe(_ sender: Any) {
        if segControl.selectedSegmentIndex > 0 {
            segControl.selectedSegmentIndex -= 1
            let newOffset = CGPoint(x: scrollView.contentOffset.x - (view.frame.width), y: scrollView.contentOffset.y)
            scrollView.setContentOffset(newOffset, animated: true)
        }
        regionName.text = nameArray[segControl.selectedSegmentIndex].capitalized
        self.fetchAreas(self)


    }
    
    // MARK: - Navigation
    
    //some locations don't have any pokemon. So instead of making an API call for every cell and then filtering that response in this view,
    //when a user taps on a location cell to view all subareas, we let them know there are no pokemon in that area, and prevent the
    //the segue to the AreaDetailVC
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let cell = sender as! InnterAreaCell
        if (cell.id).contains("Sorry,") {
            return false
        }
        return true
    }

    //need to pass the cell id (the name of the location area) to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //the inner area cell gets triggers the segue
        
        //ensuring the sender is the type of cell we want
        let cell = sender as! InnterAreaCell
        
        let detailsViewController =  segue.destination as! AreaDetailViewController
        
        detailsViewController.areaName = cell.id
        
    }
}
