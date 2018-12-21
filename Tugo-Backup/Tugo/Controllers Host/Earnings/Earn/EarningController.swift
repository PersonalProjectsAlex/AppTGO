//
//  EarningController.swift
//  Tugo
//
//  Created by Alex on 20/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Charts

class EarningController: UIViewController {

   
    // MARK: - Let-Var
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    var iosDataEntry = PieChartDataEntry(value: 3)
    var macDataEntry = PieChartDataEntry(value: 5)
    
    // MARK: - Outlets
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var earningdetailTableView: UITableView!
    @IBOutlet weak var optionSegementedControl: UISegmentedControl!
    @IBOutlet weak var secondView: UIView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       
numberOfDownloadsDataEntries = [iosDataEntry, macDataEntry]
        updateChartData()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    func updateChartData() {
        pieChart.legend.enabled = false
        pieChart.minOffset = 0.0
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setValueFont(.systemFont(ofSize: 1))
        chartData.setValueTextColor(.clear)
        
        let colors = [UIColor.lightGray, UIColor.blue]
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.chartDescription?.text = ""
        
        let myString = "70%"
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.blue ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        
        pieChart.centerAttributedText = myAttrString
        pieChart.data = chartData
       
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){
        //Tableview Delegate
        earningdetailTableView.delegate = self
        earningdetailTableView.dataSource = self
        //Set Cell Identifier
        Core.shared.registerCell(at: earningdetailTableView, named: K.cells.table.Host.incomeHeaderTableCell)
        Core.shared.registerCell(at: earningdetailTableView, named: K.cells.table.Host.incomeFooterTableCell)
        Core.shared.registerCell(at: earningdetailTableView, named: K.cells.table.Host.incomeDetailTableCell)
        
    }
    
    private func gettingData(){}
    
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch optionSegementedControl.selectedSegmentIndex
        {
        case 0:
            secondView.isHidden = true
            secondView.isUserInteractionEnabled = false
        case 1:
            secondView.isHidden = false
            secondView.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
    // MARK: - Objective C
    

}


