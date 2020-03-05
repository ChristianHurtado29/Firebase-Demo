//
//  ItemFeedViewController.swift
//  Firebase-Demo
//
//  Created by Christian Hurtado on 3/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ItemFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var listener: ListenerRegistration?
    
    var items = [Item](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
    }
}

extension ItemFeedViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
       // items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                                                       for: indexPath) as? ItemCell else {
                                                        fatalError("Could not downcast to ItemCell")
        }
//        let item = items[indexPath.row]
//        cell.configureCell(for: item)
        return cell
    }
    
    
}

extension ItemFeedViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}
