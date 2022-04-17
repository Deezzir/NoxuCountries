//
//  Country.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//

struct Country: Codable {
    var name:String    = ""
    var capital:String = ""
    var code:String    = ""
    var population:Int32 = 0
    
    var flagSrc        = ""
    
    //MARK: Mappings
    enum CodingKeys: String, CodingKey {
        case name       = "name"
        case capital    = "capital"
        case code       = "alpha3Code"
        case population = "population"
        case flags
    }
    
    enum FlagsCodingKey: String, CodingKey {
        case flagSrc    = "png"
    }
    
    func encode(to encoder: Encoder) throws {}
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let response    = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name       = try response.decodeIfPresent(String.self, forKey: .name) ?? "N/A"
        self.capital    = try response.decodeIfPresent(String.self, forKey: .capital) ?? "N/A"
        self.code       = try response.decodeIfPresent(String.self, forKey: .code) ?? "N/A"
        self.population = try response.decodeIfPresent(Int32.self, forKey: .population) ?? 0
        
        let flags       = try response.nestedContainer(keyedBy: FlagsCodingKey.self, forKey: .flags)
        
        self.flagSrc    = try flags.decodeIfPresent(String.self, forKey: .flagSrc) ?? ""
    }
}
