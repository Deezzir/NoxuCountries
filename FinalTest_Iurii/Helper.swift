//
//  Helper.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//

import Foundation
class Helper {
    static var populationCA:Int32 = 39000000

    static public func fetch(from url:URL, completion:@escaping (_ data:Data?, _ respone:URLResponse?, _ error:Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
