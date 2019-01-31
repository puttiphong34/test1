//
//  ViewController.swift
//  app1
//
//  Created by Promptnow on 8/1/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Pagecon: UIPageControl!
    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //  var thisWidth:CGFloat = 0
//    var images = [UIImage(named: "")]
    var datacollection = ["HR","iOS","TEST","Andriod"]
    var datahr = ["HR1","HR2","HR3","HR4"]
    var dataios = ["iOS1","iOS2","iOS3","iOS4"]
    var datatest = ["TEST1","TEST2","TEST3","TEST4"]
    var dataan = ["Android1","Android2","Android3","Android4"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Collection.delegate = self
        Collection.dataSource = self

        Pagecon.numberOfPages = datacollection.count
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.Collection {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            self.currentIndex = Int(pageNumber)
            Pagecon.currentPage = self.currentIndex
            
            tableView.reloadData()
        }
        
    }
}
extension ViewController: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datacollection.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! dataCollectionViewCell
        
        cell.myLabel.text = datacollection[indexPath.item]
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        }else{
            cell.backgroundColor = .lightGray

        }
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.layer.masksToBounds = true
        
        return cell
    }
   

}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentIndex == 0 {
            return datahr.count
        }else if self.currentIndex == 1 {
            return dataios.count
        }else if self.currentIndex == 2 {
            return datatest.count
        }else if self.currentIndex == 3 {
            return dataan.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if currentIndex == 0 {
            cell.textLabel?.text = datahr[indexPath.row]
        }else if currentIndex == 1 {
            cell.textLabel?.text = dataios[indexPath.row]
        }else if currentIndex == 2 {
            cell.textLabel?.text = datatest[indexPath.row]
        }else if currentIndex == 3 {
            cell.textLabel?.text = dataan[indexPath.row]
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

