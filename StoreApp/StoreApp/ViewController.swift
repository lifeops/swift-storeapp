//
//  ViewController.swift
//  StoreApp
//
//  Created by 김수현 on 2018. 8. 13..
//  Copyright © 2018년 김수현. All rights reserved.
//

import UIKit
import Toaster

var loadItems = "loadstoreItems"

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let headers = Headers().headers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 110
        NotificationCenter.default.addObserver(self, selector: #selector(loadStoreItems(notification:)), name: NSNotification.Name(rawValue: loadItems), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func loadStoreItems(notification: Notification) {
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers[section].storeItems.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.itemCell.rawValue, for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        itemCell.set(headers[indexPath.section].storeItems[indexPath.row])
        return itemCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHeader = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.headerCell.rawValue) as? HeaderCell else { return nil }
        sectionHeader.set(headers, section)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 90
        return height
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = headers[indexPath.section].storeItems[indexPath.row]
        Toast(text: item.title + "\n" + item.sPrice).show()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = tableView.rowHeight
        
        if scrollView.contentOffset.y <= scrollHeight {
            if scrollView.contentOffset.y >= 0 {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
            }
        } else if scrollView.contentOffset.y >= scrollHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollHeight, 0, 0, 0)
        }
    }
    
}

enum CellIdentifier: String {
    case itemCell
    case headerCell
}


