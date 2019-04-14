//
//  RealTimeStockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 4/12/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit
import Charts

class RealTimeStockDetailViewController: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var sevenDaysLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var percentDiffLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var stock:RealTimeStock!
    var closes:[String]!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotLoaded()
        loadData()
    }
    
    //MARK: - Load Data
    func loadData(){
        
        DownloadData.downloadRealTimeClosesForAbbr(abbr: stock.abbr, completion: { c in
            DispatchQueue.main.async {
                self.closes = c!
                self.setLoaded()
                
            }
        })
    }
    
    func makeGraph(){
        
    }
    
    //MARK: - Helper Functions
    func setLoaded(){
        self.setLabels()
        self.makeGraph()
        self.activityIndicator.stopAnimating()
        self.unHideObjects()
    }
    
    func setNotLoaded(){
        favoriteButton.layer.borderColor = primaryColor.cgColor; favoriteButton.layer.borderWidth = 2
        activityIndicator.center = self.view.center; activityIndicator.hidesWhenStopped = true; activityIndicator.isHidden = true
        activityIndicator.style = .gray
        self.hideObjects()
    }
    
    func setLabels(){
        DispatchQueue.main.async {
            self.navigationItem.title = self.stock.abbr
            self.fullNameLabel.text = self.stock.fullName
            self.dateLabel.text = self.stock.date
            self.openLabel.text = "Open: " + self.stock.open
            self.closeLabel.text = "Close: " + self.stock.close
            self.lowLabel.text = "Low: " + self.stock.low
            self.highLabel.text = "High: " + self.stock.high
            self.volumeLabel.text = "Volume: " + self.stock.volume
            self.marketCapLabel.text = "Market Cap: " + self.stock.mkrtCap
            self.percentDiffLabel.backgroundColor = self.stock.diff.contains("-") ? .red : .green
            self.percentDiffLabel.text = self.stock.diff
        }
    }
    
    func hideObjects(){
        fullNameLabel.isHidden = true
        graphView.isHidden = true
        sevenDaysLabel.isHidden = true
        dateLabel.isHidden = true
        openLabel.isHidden = true
        closeLabel.isHidden = true
        lowLabel.isHidden = true
        highLabel.isHidden = true
        volumeLabel.isHidden = true
        marketCapLabel.isHidden = true
        percentDiffLabel.isHidden = true
        favoriteButton.isHidden = true; favoriteButton.isEnabled = false
    }
    
    func unHideObjects(){
        fullNameLabel.isHidden = false
        graphView.isHidden = false
        sevenDaysLabel.isHidden = false
        dateLabel.isHidden = false
        openLabel.isHidden = false
        closeLabel.isHidden = false
        lowLabel.isHidden = false
        highLabel.isHidden = false
        volumeLabel.isHidden = false
        marketCapLabel.isHidden = false
        percentDiffLabel.isHidden = false
        favoriteButton.isHidden = false; favoriteButton.isEnabled = true
    }
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        if favoriteButton.backgroundColor == UIColor.white { //Insert to User Favorite List
            DownloadData.insertNameFavoritedList(key: currentID, abbr: stock.abbr, fullName: stock.fullName)
            favoriteButton.backgroundColor = primaryColor; favoriteButton.setTitleColor(UIColor.white, for: .normal)
        }
        else { //Delete to User Favorite List
            DownloadData.deleteNameFavoritedList(key: currentID, abbr: stock.abbr)
            favoriteButton.backgroundColor = UIColor.white; favoriteButton.setTitleColor(primaryColor, for: .normal)
        }
    }
}
