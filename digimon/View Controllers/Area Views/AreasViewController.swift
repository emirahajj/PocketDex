//
//  AreasViewController.swift
//  digimon
//
//  Created by Emira Hajj on 4/27/21.
//

import UIKit



class AreasViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, ViewStyle {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var regionName: UILabel!
    
    let segControl = UISegmentedControl()
    let defaults = UserDefaults.standard
    var imageArray = [UIImage]()
    var nameArray = [String]()
    var areas = [cellData]()
    var subcategories : [String] = []
    let dictionary = dict.init()
    let APImanager = APIHelper()
    
        
    //utilizing viewDidAppear so that the content refreshes when the user goes back to change the game version from another view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        styleController(frame: view.frame)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        segControl.removeAllSegments()
        
        let gameVersion = defaults.object(forKey: "versionGroup") as! String
        nameArray = dict.init().versionGroupLocationLookup[gameVersion]!
        imageArray = nameArray.map { UIImage(named: "\($0).png")!}
        
        let contentHeight = scrollView.bounds.height
        let contentWidth = scrollView.bounds.width * CGFloat(imageArray.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
//
        var offset = CGFloat(0)
        let subviewWidth = CGFloat(view.bounds.width)

        for index in 0..<imageArray.count {
            segControl.insertSegment(withTitle: nameArray[index], at: index, animated: false)
            let frame = CGRect(x: offset, y: 0, width: view.bounds.width, height: 300)
            
            let imgGradient = CAGradientLayer()
            imgGradient.frame = scrollView.bounds
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
        
        
        fetchAreas()


    }
    func styleController(frame: CGRect) {
        let GradientColors = dictionary.DexEntryColors
        view.createGradientLayer(frame: frame, colors: GradientColors)
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
            cell.areaName?.text = areas[indexPath.section].title
            cell.areaName.formatName()
            return cell
        } else { //this is one of the inner location cells
            let cell = tableView.dequeueReusableCell(withIdentifier: "InnterAreaCell") as! InnterAreaCell
            cell.innerAreaName.text = areas[indexPath.section].sectionData[indexPath.row - 1]
            cell.innerAreaName.formatName()
            cell.id = areas[indexPath.section].sectionData[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //these are the title rows
            if areas[indexPath.section].opened == true { //if its open, close it + reload sectopm
                areas[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                areas[indexPath.section].opened = true //if it's closed, open it, and make the API call to populate new cells with that response
                
                let sections = IndexSet.init(integer: indexPath.section)
                
                APImanager.APICall("https://pokeapi.co/api/v2/location/\(areas[indexPath.section].title)"){response in
                    let categorieObjects = response["areas"] as! [[String:Any]]
                    var categoryNames: [String] = []
                    if categorieObjects.count == 0 {
                        categoryNames.append("Sorry, no pokemon in this area!")
                    } else {
                        for category in categorieObjects {
                            categoryNames.append(category["name"] as! String)
                        }
                    }
                    self.areas[indexPath.section].sectionData = categoryNames
                    self.tableView.reloadSections(sections, with: .automatic)
                }
            }
        }
    }
    
    func fetchAreas() {
        
        APImanager.APICall("https://pokeapi.co/api/v2/region/\(nameArray[segControl.selectedSegmentIndex])"){response in
            let locations = response["locations"] as! [[String:Any]]
            var cellDataLocations : [cellData] = []
            for location in locations {
                let newCellData = cellData(opened: false, title: location["name"] as! String, sectionData: [])
                cellDataLocations.append(newCellData)
            }
            self.areas = cellDataLocations.sorted {$0.title < $1.title}
            for subCategory in self.subcategories {
                let newSub = cellData(opened: false, title: subCategory, sectionData: [])
                self.areas.append(newSub)
            }
            self.tableView.reloadData()
            
        }
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
        fetchAreas()
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
        fetchAreas()


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

        //ensuring the sender is the type of cell we want
        let cell = sender as! InnterAreaCell
        let detailsViewController =  segue.destination as! AreaDetailViewController
        detailsViewController.areaName = cell.id
        
    }
}
