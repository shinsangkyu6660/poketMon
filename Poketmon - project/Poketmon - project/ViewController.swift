//
//  ViewController.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/12/24.
//

import UIKit
import SnapKit
import CoreData


class ViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var poketList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = plusButton
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        tableviewdidset()
    }
    
    private lazy var plusButton: UIBarButtonItem = {
        self.title = "친구 목록"
        let plusButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonTapbar))
        return plusButton
    }()
    
    @objc private func plusButtonTapbar() {
        // 연락처 저장하는곳 이동하는 코드
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .green
        return tableView
    }()
    
    
    
    func tableviewdidset() {
        tableView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readAllData()
        tableView.reloadData()
    }
    
    func readAllData() {
        do{
            let Pokets = try self.container.viewContext.fetch(Poket.fetchRequest())
            for Poket in Pokets as [NSManagedObject] {
                poketList.append(Poket)
            }
        }catch {
            print("데이터 전송이 실패됫습니다.")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let item = poketList[indexPath.row]
        if let name = item.value(forKey: Poket.Key.name) as? String {
            cell.nameLabelText.text = name
        }
        if let phone = item.value(forKey: Poket.Key.number) as? String {
            cell.phoneLabelText.text = phone
        }
        if let image = item.value(forKey: Poket.Key.image) as? String, let imageUrl = URL(string: image), let data = try? Data(contentsOf: imageUrl) {
            cell.profileImage.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
