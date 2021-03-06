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
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var percentDiffLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var predictButton = UIBarButtonItem()
    var infoButton = UIBarButtonItem()
    var stock:RealTimeStock!
    var closesList:[String]!
    var predictions:[String]!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPredictButton()
    }
    
    override func viewWillAppear(_ animated: Bool) { loadData() }
    
    //MARK: - Load Data
    func loadData(){
        hideObjects()
        DownloadData.downloadFavoritesJoinRealTime(key: currentID, abbr: stock.abbr, completion: { isFavorited in
            self.checkIsFavorited(isFavorited)
            DownloadData.downloadRealTimeClosesForAbbr(abbr: self.stock.abbr, completion: { c in
                DispatchQueue.main.async {
                    self.closesList = c!
                    self.setLoaded()
                }
            })
        })
    }
    
    func createGraph() {
        DispatchQueue.main.async {
            var chartData:LineChartData!
            
            var dataEntries: [ChartDataEntry] = []
            var i = 1
            for _ in self.closesList {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(self.closesList[i - 1].replacingOccurrences(of: ",", with: ""))!)
                dataEntries.append(dataEntry)
                i += 1
            }
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label: "Actual")
            chartDataSet.setCircleColor(NSUIColor(cgColor: UIColor.clear.cgColor))
            chartDataSet.circleHoleColor = NSUIColor(cgColor: primaryColor.cgColor)
            chartDataSet.setColors(NSUIColor(cgColor: primaryColor.cgColor))
            
            if(self.predictions != nil) {
                var x = 1
                var predictionDataEntries: [ChartDataEntry] = [dataEntries[dataEntries.count - 1]]
                for _ in self.predictions {
                    let dataEntry = ChartDataEntry(x: Double(i), y: Double(self.predictions[x - 1])!)
                    predictionDataEntries.append(dataEntry)
                    i += 1
                    x += 1
                }
                
                let predictionDataSet = LineChartDataSet(values: predictionDataEntries, label: "Predicted")
                predictionDataSet.setCircleColor(NSUIColor(cgColor: UIColor.clear.cgColor))
                predictionDataSet.circleHoleColor = NSUIColor(cgColor: UIColor.black.cgColor)
                predictionDataSet.setColors(NSUIColor(cgColor: UIColor.black.cgColor))
                
                chartData = LineChartData(dataSets: [predictionDataSet, chartDataSet])
            }else{
                chartData = LineChartData(dataSet: chartDataSet)
            }
            
            self.graphView.data = chartData
            self.graphView.chartDescription?.text = "Price"
        }
    }
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        if favoriteButton.backgroundColor == UIColor.white { //Insert to User Favorite List
            DownloadData.insertNameFavoritedList(key: currentID, abbr: stock.abbr, fullName: stock.fullName)
            favoriteButton.backgroundColor = primaryColor; favoriteButton.setTitleColor(UIColor.white, for: .normal)
            favoriteButton.setTitle("Favorited!", for: .normal)
        }
        else { //Delete to User Favorite List
            DownloadData.deleteNameFavoritedList(key: currentID, abbr: stock.abbr)
            favoriteButton.backgroundColor = UIColor.white; favoriteButton.setTitleColor(primaryColor, for: .normal)
            favoriteButton.setTitle("Favorite", for: .normal)
        }
    }
    
    //MARK: - Prediction
    @objc func makePrediction(){
        let alert = UIAlertController(title: "How long in the future would you like to predict this stock?", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "1 day", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 1, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "2 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 2, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "3 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 3, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "5 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 5, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "7 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 7, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "15 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 15, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        alert.addAction(UIAlertAction(title: "30 days", style: .default , handler:{ (UIAlertAction) in
            DownloadData.getPrediction(abbr: self.stock.abbr, length: 30, completion: {
                p in self.predictions = p
                self.createGraph()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    fileprivate func setUpPredictButton() {
        predictButton = UIBarButtonItem(title: "Predict", style: .plain, target: self, action: #selector(makePrediction))
        predictButton.tintColor = UIColor.white
        infoButton = UIBarButtonItem(title: "?     ", style: .plain, target: self, action: #selector(showInfo))
        navigationItem.rightBarButtonItems = [predictButton, infoButton]
    }
    @objc func showInfo(){
        Utils.createAlertWith(message: "This graph will show the last 7 days of real time data!", viewController: self)
    }
    
    func checkIsFavorited(_ isFavorited: Bool) {
        DispatchQueue.main.async {
            if isFavorited {
                self.favoriteButton.backgroundColor = primaryColor
                self.favoriteButton.setTitleColor(.white, for: .normal)
                self.favoriteButton.setTitle("Favorited!", for: .normal)
            }
            else{
                self.favoriteButton.backgroundColor = UIColor.white
                self.favoriteButton.setTitleColor(primaryColor, for: .normal)
                self.favoriteButton.setTitle("Favorite", for: .normal)
            }
        }
    }
    
    func setLoaded(){
        self.setLabels()
        self.createGraph()
        self.activityIndicator.stopAnimating()
        self.unHideObjects()
    }
    
    func setLabels(){
        DispatchQueue.main.async {
            self.navigationItem.title = self.stock.abbr
            self.fullNameLabel.text = self.stock.fullName
            self.openLabel.text = " Open: " + self.stock.open + " "
            self.closeLabel.text = " Close: " + self.stock.close + " "
            self.lowLabel.text = " Low: " + self.stock.low + " "
            self.highLabel.text = " High: " + self.stock.high + " "
            self.volumeLabel.text = " Volume: " + self.stock.volume + " "
            self.marketCapLabel.text = " Market Cap: " + self.stock.mkrtCap + " "
            self.percentDiffLabel.backgroundColor = self.stock.diff.contains("-") ? .red : .green
            self.percentDiffLabel.text = self.stock.diff
        }
    }
    
    func hideObjects(){
        favoriteButton.layer.borderColor = primaryColor.cgColor; favoriteButton.layer.borderWidth = 2
        activityIndicator.center = self.view.center; activityIndicator.hidesWhenStopped = true; activityIndicator.isHidden = true
        activityIndicator.style = .gray
        fullNameLabel.isHidden = true
        graphView.isHidden = true
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
        openLabel.isHidden = false
        closeLabel.isHidden = false
        lowLabel.isHidden = false
        highLabel.isHidden = false
        volumeLabel.isHidden = false
        marketCapLabel.isHidden = false
        percentDiffLabel.isHidden = false
        favoriteButton.isHidden = false; favoriteButton.isEnabled = true
    }
}
