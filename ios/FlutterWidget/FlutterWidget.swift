//
//  FlutterWidget.swift
//  FlutterWidget
//
//  Created by georgy garbuzov on 25.05.2021.
//

import WidgetKit
import SwiftUI
import Intents
import LightChart

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: FlutterWidgetIntent(), widgetData: nil)
    }
    
    func getSnapshot(for configuration: FlutterWidgetIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, widgetData: nil)
        completion(entry)
    }
    
    func getTimeline(for configuration: FlutterWidgetIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let range: Int
        switch configuration.chartDateRange {
        case .value:
            range = 7
        case .value1:
            range = 30
        case .value2:
            range = 365
        default:
            range = 7
        }
        WidgetDataService.fetchWidgetData(gauge_station: "tura-tumen", range: range){ (widgetData, error) in
            let entryDate: Date
            let currentDate = Date()
            if let widgetData = widgetData {
                if widgetData.date == currentDate {
                    entryDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
                } else {
                    entryDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                }
            } else {
                entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            }
            let entry = SimpleEntry(date: entryDate, configuration: configuration, widgetData: widgetData)
            let entries: [SimpleEntry] = [entry]
            let timeline = Timeline(entries: entries, policy: .after(entryDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: FlutterWidgetIntent
    let widgetData: WidgetData?
}

struct FlutterWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry
    
    let increaseColor = Color.green
    let decreaseColor = Color.red;
    
    var chartView: some View {
        LightChartView(
            data: entry.widgetData?.levels.map { Double($0) } ?? [300,305,315,320,327,335,340],
            type: .curved,
            visualType: .customFilled(
                color: Color.blue.opacity(0.7),
                lineWidth: 2,
                fillGradient: LinearGradient(
                    gradient: Gradient(
                        colors: [Color.clear, Color.blue.opacity(0.5)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            ),
            offset: 0.2,
            currentValueLineType: .dash(color: .gray, lineWidth: 1, dash: [5])
        )
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 5){
                Text(entry.widgetData?.title ?? "-")
                    .font(Font.system(size: 16).weight(.bold))
                Text(entry.widgetData?.subTitle ?? "-")
                    .font(Font.system(size: 14).weight(.regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                HStack{
                    Text(entry.widgetData?.currentLevel ?? "-")
                        .font(Font.system(size: 16).weight(.bold))
                    if entry.widgetData?.diffLevelText != nil {
                        Text(entry.widgetData?.diffLevelText ?? "-")
                            .font(Font.system(size: 14).weight(.bold))
                            .foregroundColor(entry.widgetData?.increaseLevel ?? false ? increaseColor : decreaseColor)
                    }
                }
                if entry.widgetData?.date != nil {
                    Text(entry.widgetData?.date ?? Date(), style: .date)
                        .font(Font.system(size: 12).weight(.medium))
                } else {
                    Text("-").font(Font.system(size: 12).weight(.medium))
                }
            }
            if widgetFamily != .systemSmall {
                chartView
            }
        }
        .padding()
        .clipShape(ContainerRelativeShape())
    }
}

@main
struct FlutterWidget: Widget {
    let kind: String = "FlutterWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: FlutterWidgetIntent.self,
                            provider: Provider()) { entry in
            FlutterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("")
        .description("")
        .supportedFamilies([.systemMedium])
    }
}

struct FlutterWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlutterWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: FlutterWidgetIntent(), widgetData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
