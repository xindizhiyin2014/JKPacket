//
//  ViewController.swift
//  JKPacket
//
//  Created by xindizhiyin2014 on 03/18/2022.
//  Copyright (c) 2022 xindizhiyin2014. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
private var datas = [String]()
    private var tableView:UITableView = {
        let table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        initDatas()
    }
    
    private func initDatas()
    {
        datas = ["observe lifecycle data", "observe lifecycle data with rxswift", "observe lifecycle data on mainthread", "observe lifecycle data with buffer", "lifecycleView"]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

 extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.row == 0 {
             let vc = JKObserveLifeCycleDataViewController()
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 1 {
             let vc = JKObserveLifeCycleDataViewController2()
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 2 {
             let vc = JKObserveLifeCycleDataViewController3()
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 3 {
             let vc = JKObserveLifeCycleDataViewController4()
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 4 {
             let vc = JKObserveLifeCycleDataViewController5()
             self.navigationController?.pushViewController(vc, animated: true)
         }
         
     }
     
     
    
}

