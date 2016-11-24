//
//  ViewController.swift
//  scrollDemo
//
//  Created by 徐健 on 2016/11/21.
//  Copyright © 2016年 徐健. All rights reserved.
//

import UIKit

enum ScrollDirection {
    case up
    case down
    case unknown
}

class ViewController: UIViewController {
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    var testTableView: UITableView!
    var shieldView: UIView!
    var lastPostion = CGPoint(x: 0.0, y: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shieldView = UIView.init(frame: CGRect.init(x: 0, y: 64, width: kScreenWidth, height: 100))
        shieldView.backgroundColor = .blue
        self.view.addSubview(shieldView)
        
        testTableView = UITableView()
        testTableView.frame = CGRect(x: 0, y: shieldView.frame.origin.y + shieldView.frame.size.height, width: kScreenWidth, height: kScreenHeight - shieldView.frame.size.height - shieldView.frame.origin.y)
        testTableView.backgroundColor = .white
        testTableView.dataSource = self
        testTableView.delegate = self
        self.view.addSubview(testTableView)
        self.testTableView.alwaysBounceVertical = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
}



extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "testCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        }
        cell?.textLabel?.text = "test \(indexPath.row)"
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPostion = scrollView.contentOffset
        let scrollDirection: ScrollDirection =
            currentPostion.y > lastPostion.y ? .down : .up
        lastPostion = currentPostion
        if scrollDirection == .down && scrollView.contentOffset.y > 85.0 {
            UIView.animate(withDuration: 0.7, animations: {
                self.navigationController?.navigationBar.alpha = 0
                self.navigationController?.navigationBar.frame = CGRect(origin: CGPoint.init(x: 0, y: -24), size: (self.navigationController?.navigationBar.frame.size)!)
                self.shieldView.frame = CGRect(origin: CGPoint.init(x: 0, y: 20), size: self.shieldView.frame.size)
                self.testTableView.frame = CGRect(origin: CGPoint.init(x: 0, y: 120), size: self.testTableView.frame.size)
            })
            let time: TimeInterval = 2.0
            
            let delay = DispatchTime.init(uptimeNanoseconds: UInt64(time * Double(NSEC_PER_SEC)))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                print("after")
            })

        }else{
            UIView.animate(withDuration: 0.7, animations: {
                self.navigationController?.navigationBar.isHidden = false
//                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.navigationBar.frame = CGRect(origin: CGPoint.init(x: 0, y: 20), size: (self.navigationController?.navigationBar.frame.size)!)
                self.shieldView.frame = CGRect(origin: CGPoint.init(x: 0, y: 64), size: self.shieldView.frame.size)
                self.testTableView.frame = CGRect(origin: CGPoint.init(x: 0, y: 164), size: self.testTableView.frame.size)
            })
        }
//        print(currentPostion)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(velocity.y)
        
    }
}

