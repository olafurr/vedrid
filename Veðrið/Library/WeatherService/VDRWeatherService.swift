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

    
    static let sharedInstance = VDRWeatherAPI();
    
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
            case .Observation(let ids): return ("/", ["ids": arrayToString(ids), "op_w": "xml", "type": "forec", "view": "xml"]);
            }
        }
        
        var URLRequest: NSMutableURLRequest {
            return Alamofire
                .ParameterEncoding
                .URL
                .encode(NSURLRequest(URL: URL), parameters: (route.parameters ?? [:])).0;
        }
    }
    
    
    func getWeather(ids: [Int]) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            let request: Request = Alamofire.request(Router.Forecast(ids));

            request.responseData { response in
                
                if (response.result.isSuccess) {
                    let xml = SWXMLHash.lazy(response.result.value!);
                    
                    let forecasts: [VDRForecast] = xml["forecasts"]["station"]["forecast"].all.map({ elem in
                        var forecast = VDRForecast();
                        forecast.weatherDescription = elem["W"].element!.text;
                        return forecast;
                    });
                    
                    subscriber.sendNext(xml["forecasts"].element);
                    subscriber.sendCompleted();
                } else {
                    subscriber.sendError(response.result.error);
                }
                
            };
            
            return RACDisposable(block: { () -> Void in
                request.cancel();
            });
        });
    }
    
}
