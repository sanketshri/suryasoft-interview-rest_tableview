//
//  ResultVC.swift
//  Sankets-TestApp
//
//  Created by Sanket on 29/11/18.
//  Copyright © 2018 Developer Sanket. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class ResultVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    let searchAPI = SearchAPI()
    var items:[Items]?
    var searchKey:String?


    
    @IBOutlet weak var resultTable: UITableView!

    @IBAction func back_Button(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showResult()

    }


    func showResult(){

        if searchKey != nil{
            searchAPI.getSearchResult(searchKeyword: searchKey!) { (response, error) in
            if response != nil{
                self.items = (response!.items)
                self.resultTable.reloadData()

               }
            }
        } else {
            print("ResultVC : searchKey is nil")
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items != nil{
            return items!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        let name = cell.viewWithTag(2) as! UILabel
        if items != nil{
        if (items![indexPath.row].firstName) != nil && (items![indexPath.row].lastName) != nil{
        name.text = "\(items![indexPath.row].firstName!) \(items![indexPath.row].lastName!)"
        }else if (items![indexPath.row].firstName) != nil{
            name.text = "\(items![indexPath.row].firstName!)"
        }else{
            print("ResultVC : No name for index no. \(indexPath.row)")
        }
        let email_Id = cell.viewWithTag(3) as! UILabel
        if (items![indexPath.row].emailId) != nil{
            email_Id.text = (items![indexPath.row].emailId!)
        }

           if (items![indexPath.row].imageUrl) != nil{
            let imageURL = URL(string: (items![indexPath.row].imageUrl!))
            let request = URLRequest(url: imageURL!)
        let image = cell.viewWithTag(1) as! UIImageView
            image.af_setImage(withURLRequest:request, placeholderImage: nil, filter: nil, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
            }
        }

        return cell
    }



}
