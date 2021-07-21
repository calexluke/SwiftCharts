//
//  CubicLinesExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class CubicLinesWithGradientExample: UIViewController {
    
    fileprivate var chart: Chart? // arc
    var timer: Timer?
    var dataPoints = [(0, 0)]
    var xCounter = 0
    var yCounter = 5
    var dataIsIncreasing = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawChart()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func drawChart() {
        self.chart?.clearView()
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

        let chartPoints = dataPoints.map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        
        let xValues = chartPoints.map{$0.x}
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(view.bounds)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColors: [UIColor.yellow, UIColor.red], lineWidth: 2, animDuration: 0, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel], pathGenerator: CatmullPathGenerator()) // || CubicLinePathGenerator
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
            ]
        )
        
        view.addSubview(chart.view)
        self.chart = chart
    }
    
    @objc func timerFired() {
        xCounter += 1
        let offset = Int.random(in: -2...2)
        let yValue = yCounter + offset
        
        self.dataPoints.append((xCounter, yValue))
        
        if xCounter > 500 {
            self.dataPoints.removeFirst()
        }
        
        if xCounter % 10 == 0 {
            dataIsIncreasing.toggle()
        }
        
        if dataIsIncreasing {
            yCounter += 1
        } else {
            yCounter -= 1
        }
        
        drawChart()
    }
}

