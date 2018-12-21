//
//  ExperienceIncomeDetailController.swift
//  Tugo
//
//  Created by Alex on 21/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Charts


class ExperienceIncomeDetailController:UIViewController {
    
    
    // MARK: - Let-Var
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    var iosDataEntry = PieChartDataEntry(value: 3)
    var macDataEntry = PieChartDataEntry(value: 5)
    
    // MARK: - Outlets
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var earningdetailTableView: UITableView!
   
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
        pieChart.minOffset = 0.0
        pieChart.legend.enabled = false
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setValueFont(.systemFont(ofSize: 2))
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
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    
    
}


