//
//  StockDetailViewController.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/25/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Variables
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    var stockAbbr:String!
    var stockName:String!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var segmantControl: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var monthList:[(numberDate: String, humanDate: String)] = []
    var yearList:[String] = ["2018", "2017", "2016", "2015", "2014", "2013"]
    var dataList:[(date: String, close: String)] = []
    var lastIndexPath:IndexPath!
    
    //MARK: - Views Appearing
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stockAbbr
        nameLabel.text = stockName!
        graphView.layer.borderColor = UIColor.black.cgColor;
        graphView.layer.borderWidth = 1
        lastIndexPath = IndexPath(row: 0, section: 0)
        segmantControl.setEnabled(true, forSegmentAt: 0)
        disableView()
        DownloadData.downloadPossibleMonths(abbr: stockAbbr, completion: { m in
            DispatchQueue.main.async {
                self.generateMonthList(m: m!)
                self.tableView.reloadData()
                self.loadMonthlyData(month: String(self.monthList[0].numberDate.dropLast(3)))
            }
        })
    }
    
    //MARK: - Loading Data
    func loadMonthlyData(month: String){
        disableView()
        DownloadData.downloadUniqueStockDataForMonth(abbr: stockAbbr, month: month, completion: { data in
            DispatchQueue.main.async {
                self.dataList = data!
                //JOEY THIS IS WHERE YOU NEED TO MAKE THE GRAPH WITH THIS DATA THIS IS THE CLOSING TIME FOR EACH DAY IN THE MONTH
                self.enableView()
            }
        })
    }
    
    func loadYearlyData(year: String){
        disableView()
        DownloadData.downloadUniqueStockDataForYear(abbr: stockAbbr, year: year, completion: { data in
            DispatchQueue.main.async {
                self.dataList = data!
                //JOEY THIS IS WHERE YOU NEED TO MAKE THE GRAPH WITH THIS DATA THIS IS THE CLOSING TIME FOR EACH DAY IN THE YEAR
                self.enableView()
            }
        })
    }
    
    func generateMonthList(m: [String]){
        for month in m {
            self.monthList.append((month, stringToHumanDate(d: month)))
        }
        self.monthList.reverse()
    }
    
    //MARK: - Segmented Control
    @IBAction func segmantControlChanged(_ sender: UISegmentedControl) {
        lastIndexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false)
        if segmantControl.selectedSegmentIndex == 0 { loadMonthlyData(month: String(monthList[0].numberDate.dropLast(3))) }
        else{ loadYearlyData(year: yearList[0]) }
    }
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmantControl.selectedSegmentIndex == 0 { return monthList.count }
        else { return yearList.count }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 50 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StockDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockDetailCell") as! StockDetailTableViewCell
        if segmantControl.selectedSegmentIndex == 0 { cell.dataLabel.text = monthList[indexPath.row].humanDate }
        else { cell.dataLabel.text = yearList[indexPath.row] }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        if segmantControl.selectedSegmentIndex == 0 { loadMonthlyData(month: String(monthList[indexPath.row].numberDate.dropLast(3))) }
        else { loadYearlyData(year: yearList[indexPath.row]) }
    }
    
    //MARK: - Helper Functions
    func stringToHumanDate(d: String) -> String {
        let dateFormatterGet = DateFormatter(); dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterPrint = DateFormatter(); dateFormatterPrint.dateFormat = "YYYY - MMMM"
        return dateFormatterPrint.string(from: dateFormatterGet.date(from: d)!)
    }
    
    func disableView(){
        activityIndicator.isHidden = false; activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        tableView.isHidden = true; tableView.isScrollEnabled = false; tableView.separatorStyle = .none
    }
    
    func enableView() {
        self.activityIndicator.stopAnimating()
        self.tableView.isHidden = false; self.tableView.isScrollEnabled = true;
        self.tableView.separatorStyle = .singleLine
        self.tableView.reloadData()
        self.tableView.selectRow(at: self.lastIndexPath, animated: false, scrollPosition: .none)
    }
}
