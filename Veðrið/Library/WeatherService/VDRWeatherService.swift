//
//  VDRWeatherService.swift
//  Veðrið
//
//  Created by Ólafur Garðarsson on 03/11/15.
//  Copyright © 2015 Ólafur Garðarsson. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveCocoa
import SWXMLHash



class VDRWeatherAPI: NSObject {
    
    let dateFormatter: NSDateFormatter = NSDateFormatter();
    static let sharedInstance = VDRWeatherAPI();
    
    
    override init() {
        super.init();
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss";
    }
    
    enum Router: URLRequestConvertible {
        static let BASE_URL = NSURL(string: "http://xmlweather.vedur.is")!;
        
        
        case Forecast([Int]);
        case Observation([Int]);
        
        private func arrayToString(arr: Array<Int>) -> String {
            var str = "";
            
            for (idx, id) in arr.enumerate() {
                str += String(id);
                if idx != arr.count - 1 {
                    str += ",";
                }
            }

            return str;
        }
        
        
        
        var URL : NSURL {
            return Router.BASE_URL.URLByAppendingPathComponent(route.path);
        }
        
        var route: (path: String, parameters: [String: AnyObject]?) {
            switch self {
            case .Forecast(let ids) : return ("/", ["ids": arrayToString(ids), "op_w": "xml", "type": "forec", "view": "xml", "anytime": "1", "params": "F;D;T;W;R"]);
            case .Observation(let ids): return ("/", ["ids": arrayToString(ids), "op_w": "xml", "type": "obs", "view": "xml", "anytime": "1", "params": "F;D;T;P;R"]);
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            return Alamofire
                .ParameterEncoding
                .URL
                .encode(NSURLRequest(URL: URL), parameters: (route.parameters ?? [:])).0;
        }
    }
    
    /* Endpoints */
    
    func getForecast(ids: [Int]) -> SignalProducer <VDRForecast, NSError> {
        
        return SignalProducer { observer, disposable in
            let request: Request = Alamofire.request(Router.Forecast(ids));
            
            request.responseData { response in
                
                if (response.result.isSuccess) {
                    let xml = SWXMLHash.lazy(response.result.value!);
                    
                    
                    let forecastItems: [VDRWeatherItem] = xml["forecasts"]["station"]["forecast"].all.map({ elem in
                        let dateString: String = elem["ftime"].element!.text!;
                        
                        let date: NSDate? = self.dateFormatter.dateFromString(dateString);
                        return VDRWeatherItem(
                            time: date,
                            windSpeed: Double(elem["F"].element!.text!),
                            windDirection: elem["D"].element!.text,
                            weatherDescription: elem["W"].element!.text,
                            totalRain: Double(elem["R"].element!.text!.stringByReplacingOccurrencesOfString(",", withString: "."))
                        );
                    });
                    
                    let forecast = VDRForecast(items: forecastItems, stationName: xml["forecasts"]["station"]["name"].element!.text);
                    
                    observer.sendNext(forecast);
                    observer.sendCompleted();
                } else {
                    observer.sendFailed(response.result.error!);
                }
                
            };
        
            disposable.addDisposable({
                request.cancel();
            });
            
        };
    }

    func getObservation(ids: [Int]) -> SignalProducer <VDRObservation, NSError> {
        return SignalProducer { observer, disposable in
            let request: Request = Alamofire.request(Router.Observation(ids));
            
            request.responseString { response in
                
                if (response.result.isSuccess) {
                    let xml = SWXMLHash.parse(response.result.value!)["observations"]["station"];

                    let dateString: String = xml["time"].element!.text!;
                    let date: NSDate? = self.dateFormatter.dateFromString(dateString);
                    
                    let observation = VDRObservation(
                        time: date,
                        windSpeed: Double(xml["F"].element!.text!),
                        windDirection: xml["D"].element!.text,
                        totalRain: Double(xml["R"].element!.text!.stringByReplacingOccurrencesOfString(",", withString: ".")),
                        pressure: Double(xml["F"].element!.text!)
                    );
                    
                    observer.sendNext(observation);
                    observer.sendCompleted();
                } else {
                    observer.sendFailed(response.result.error!);
                }
                
            };
            
            disposable.addDisposable({
                request.cancel();
            });
            
        };

    }
    
}
