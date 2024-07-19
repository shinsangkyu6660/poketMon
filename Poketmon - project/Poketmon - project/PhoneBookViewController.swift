//
//  PhoneBookViewController.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/12/24.
//

import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    var imageProfile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        layoutView()
        self.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = pushButton
    }
    
    private lazy var pushButton: UIBarButtonItem = {
        let plusButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(pushButtonTapbar))
        return plusButton
    }()
    
    @objc private func pushButtonTapbar() {
        createData(name: nameTextView.text, number: phoneTextView.text, image: imageProfile)
        self.navigationController?.popViewController(animated: true)
    }
    
    func createData(name: String, number: String, image: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Poket", in: self.container.viewContext) else { return }
        
        let newPoket = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        newPoket.setValue(name, forKey: "name")
        newPoket.setValue(number, forKey: "number")
        newPoket.setValue(image, forKey: "image")
        
        do {
            try self.container.viewContext.save()
            print("문맥 저장이 성공했습니다.")
        } catch {
            print("문맥 저장이 실패했습니다.")
        }
    }
    
    private let profileimage: UIImageView = {
        let profileimage = UIImageView()
        profileimage.layer.cornerRadius = 100
        profileimage.layer.borderColor = UIColor.gray.cgColor
        profileimage.layer.borderWidth = 5
        profileimage.clipsToBounds = true
        return profileimage
    }()
    
    private lazy var randomButton: UIButton = {
        let randomButton = UIButton()
        randomButton.setTitle("랜덤 이미지 생성", for: .normal)
        randomButton.setTitleColor(.black, for: .normal)
        randomButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        randomButton.addTarget(self, action: #selector(randomButtonTap), for: .touchDown)
        return randomButton
    }()
    
    private let nameTextView: UITextView = {
        let nameTextView = UITextView()
        nameTextView.font = .boldSystemFont(ofSize: 15)
        nameTextView.layer.cornerRadius = 10
        return nameTextView
    }()
    
    private let phoneTextView: UITextView = {
        let phoneTextView = UITextView()
        phoneTextView.font = .boldSystemFont(ofSize: 15)
        phoneTextView.layer.cornerRadius = 10
        return phoneTextView
    }()
    
    private func layoutView() {
        [profileimage, randomButton, nameTextView, phoneTextView].forEach { view.addSubview($0) }
        
        profileimage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
        randomButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileimage.snp.bottom).offset(20)
            $0.width.equalTo(130)
            $0.height.equalTo(50)
        }
        
        nameTextView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randomButton.snp.bottom).offset(40)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        phoneTextView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextView.snp.bottom).offset(20)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func randomButtonTap() {
        print("랜덤 이미지가 클릭 되었습니다.")
        let randomimage = Int.random(in: 1...1000)
        let url = "https://pokeapi.co/api/v2/pokemon/\(randomimage)"
        guard let PoketMonapi = URL(string: url) else {
            print("잘못된 URL입니다.")
            return
        }
        
        fetchData(url: PoketMonapi) { [weak self] (result: PoketMonAPI?) in
            guard let self = self, let result else { return }
            guard let imageUrl = URL(string: result.sprites.frontDefault) else { return }
            imageProfile = result.sprites.frontDefault
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileimage.image = image
                    }
                } else {
                    print("이미지 변환을 실패했습니다.")
                }
            }
        }
    }
    
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // http status code 성공 범위.
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
}
