//
//  firebaseVC.swift
//  WeClimb
//
//  Created by mac on 8/30/24.
//

import UIKit
import SnapKit
import FirebaseCore
import FirebaseFirestore


class firebaseVC: UIViewController {
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        //        let citiesRef = db.collection("cities")
        //
        //        citiesRef.document("SF").setData([
        //          "name": "San Francisco",
        //          "state": "CA",
        //          "country": "USA",
        //          "capital": false,
        //          "population": 860000,
        //          "regions": ["west_coast", "norcal"]
        //        ])
        //        citiesRef.document("LA").setData([
        //          "name": "Los Angeles",
        //          "state": "CA",
        //          "country": "USA",
        //          "capital": false,
        //          "population": 3900000,
        //          "regions": ["west_coast", "socal"]
        //        ])
        //        citiesRef.document("DC").setData([
        //          "name": "Washington D.C.",
        //          "country": "USA",
        //          "capital": true,
        //          "population": 680000,
        //          "regions": ["east_coast"]
        //        ])
        //        citiesRef.document("TOK").setData([
        //          "name": "Tokyo",
        //          "country": "Japan",
        //          "capital": true,
        //          "population": 9000000,
        //          "regions": ["kanto", "honshu"]
        //        ])
        //        citiesRef.document("BJ").setData([
        //          "name": "Beijing",
        //          "country": "China",
        //          "capital": true,
        //          "population": 21500000,
        //          "regions": ["jingjinji", "hebei"]
        //        ])
        //        // Do any additional setup after loading the view.
        //    }
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
    
    
    // [START codable_struct]
    public struct City: Codable {
        
        let name: String
        let state: String?
        let country: String?
        let isCapital: Bool?
        let population: Int64?
        
        enum CodingKeys: String, CodingKey {
            case name
            case state
            case country
            case isCapital = "capital"
            case population
        }
        
    }
    // [END codable_struct]
}
