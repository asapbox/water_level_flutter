//
//  WidgetDataProvider.swift
//  FlutterWidgetExtension
//
//  Created by georgy garbuzov on 26.06.2021.
//

import Foundation

class WidgetDataService {
    static func fetchWidgetData(gauge_station: String, range: Int?, completion:@escaping (WidgetData?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let urlString = "https://wl.vpsss.ru/api/v1/widgets?gauge_station=\(gauge_station)&day_range=\(range ?? 7)"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                print(responseData)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
                let widgetData = try decoder.decode(WidgetData.self, from: responseData)
                completion(widgetData, nil)
            } catch let parsingError {
                print("Error", parsingError)
                completion(nil, parsingError)
            }
        }
        task.resume()
    }
}

struct WidgetData: Decodable, Hashable {
    let title: String?
    let subTitle: String?
    let currentLevel: String?
    let diffLevelText: String?
    let levels: [Int]
    let increaseLevel: Bool?
    let date: Date?
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
