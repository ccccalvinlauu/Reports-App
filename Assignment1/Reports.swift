//
//  reports.swift
//  COMP327.Assignment1.u6tcl.Lau.TszChung
//
//  Created by lau tszchung on 29/10/2018.
//  Copyright © 2018 lau tszchung. All rights reserved.
//
//  Struct of report to Retrieve JSON Data

import Foundation

struct Report{
    //fields
    
    let year: String
    let id: String
    let title: String
    let owner: String?
    let authors: String
    let abstract: String?
    let pdf: String?
    let comment: String?
    let lastModified: String
    var hasfavourited : Bool
    
    //Enumerations
    enum Serror:Error {
        case missing(String)
        case invalid(String:Any)
    }
    
    //init for struct report
    init(json:[String:Any?] ) throws {
        guard let year =  json["year"] as? String else{throw Serror.missing("year is missing")}
        guard let id =  json["id"] as? String else{throw Serror.missing("id is missing")}
        guard let title =  json["title"] as? String else{throw Serror.missing("title is missing")}
        guard let owner =  json["owner"] as? String? else{throw Serror.missing("owner is missing")}
        guard let authors =  json["authors"] as? String else{throw Serror.missing("authors is missing")}
        guard let abstract =  json["abstract"] as? String? else{throw Serror.missing("abstract is missing")}
        guard let pdf =  json["pdf"] as? String? else{throw Serror.missing("pdf is missing")}
        guard let comment =  json["comment"] as? String? else{throw Serror.missing("comment is missing")}
        guard let lastModified =  json["lastModified"] as? String else{throw Serror.missing("lastModified is missing")}
        
        self.year = year
        self.id = id
        self.title = title
        self.owner = owner
        self.authors = authors
        self.abstract = abstract
        self.pdf = pdf
        self.comment = comment
        self.lastModified = lastModified
        self.hasfavourited = false
        
    }
    
    
    // Static function that Retrieve Data from JSON using JSONSerialization
    // Completion handler to return an array of objects(Report)
    static func details (completion: @escaping([Report]) -> ()){
        let url = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP327/techreports/data.php?class=techreports"
        let request = URLRequest(url: URL(string:url)!)
        
        //URL Session
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var DataArray:[Report] = []
            if let data = data {
                
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any?]{
                        if let techreports = json["techreports"] as? [[String: Any?]] {
                            for dataPoint in techreports {
                                if let reportObject = try? Report(json: dataPoint) {
                                    DataArray.append(reportObject)
                                }
                            }
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                completion(DataArray)
            }
            
        }
        
        task.resume()
    }
    
}

