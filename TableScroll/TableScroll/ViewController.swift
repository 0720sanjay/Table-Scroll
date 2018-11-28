//
//  ViewController.swift
//  TableScroll
//
//  Created by Lalit Arya on 28/11/18.
//  Copyright © 2018 Lalit Arya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerViewReduceHeightAtScrollUpDelegate : HeaderViewReduceHeightAtScrollUpDelegate? = nil
    var headerViewExpandHeightAtScrollDownDelegate : HeaderViewExpandHeightAtScrollDownDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerViewReduceHeightAtScrollUpDelegate = HeaderViewReduceHeightAtScrollUpDelegate(headerView: self.headerView, scrollView: self.tableView)
        self.headerViewExpandHeightAtScrollDownDelegate = HeaderViewExpandHeightAtScrollDownDelegate(headerView: self.headerView, scrollView: self.tableView)
        
    }
    
}

