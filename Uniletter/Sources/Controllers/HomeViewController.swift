//
//  HomeViewController.swift
//  Uniletter
//
//  Created by 권오준 on 2022/06/27.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {
    
    let homeView = HomeView()
    let viewModel = HomeViewModel()
    let loginManager = LoginManager.shared
    // FIXME: viewModel 싱글톤 안쓰셔도 돼요! 밑에 FIXME에 주석 달아놓을게요!
    let myPageViewModel = MyPageViewModel.shared

    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setViewController()
        checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addGradientLayer()
    }
    
    func setNavigationBar() {
        let topLogo: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            button.setBackgroundImage(
                UIImage(named: "UniletterLabel"),
                for: .normal)
            button.isUserInteractionEnabled = false
            
            return button
        }()
        
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let myInfo = UIBarButtonItem(
            image: UIImage(
                systemName: "person", withConfiguration: config)?
                .withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(goToInfo))
        
        self.navigationItem.leftBarButtonItems = [
            spacingItem(15),
            UIBarButtonItem(customView: topLogo),
        ]
        self.navigationItem.rightBarButtonItems = [
            spacingItem(10),
            myInfo,
        ]
        
        let navigationBarLayer = self.navigationController?.navigationBar.layer
        navigationBarLayer?.shadowColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1).cgColor
        navigationBarLayer?.shadowOpacity = 0.6
        navigationBarLayer?.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func setViewController() {
        homeView.collectionView.dataSource = self
        homeView.collectionView.delegate = self
        
        homeView.writeButton.addTarget(
            self,
            action: #selector(goToWrite(_:)),
            for: .touchUpInside)
    }
    
    func fetchEvents() {
        DispatchQueue.global().async {
            self.viewModel.loadEvents() {
                DispatchQueue.main.async {
                    self.homeView.collectionView.reloadData()
                }
            }
        }
    }
    
    func checkLogin() {
        loginManager.checkLogin() {
            print("로그인 상태: \(self.loginManager.isLoggedIn)")
        }
    }
    
    func addGradientLayer() {
        homeView.gradientView.layer.sublayers?.removeAll()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor,
            UIColor.white.cgColor
        ]
        gradient.frame = homeView.gradientView.bounds
        homeView.gradientView.layer.addSublayer(gradient)
    }
    
    
    @objc func goToInfo(_ sender: UIBarButtonItem) {
        if loginManager.isLoggedIn {
            let myPageViewController = MyPageViewController()
            self.navigationController?.pushViewController(myPageViewController, animated: true)
            // FIXME: MyPageVC didLoad나 willAppear에서 fetch 전에 API 호출하시면 될거 같아요!
            myPageViewModel.setUserInfo {
                DispatchQueue.global().async {
                    self.myPageViewModel.userName = self.myPageViewModel.setUserNickName()
                    self.myPageViewModel.userImage = self.myPageViewModel.setUserImage()
                }
            }
        } else {
            presentAlertView(.login)
        }
    }
    
    @objc func goToWrite(_ sender: UIButton) {
        if loginManager.isLoggedIn {
            // TODO: 글쓰기
            /// 임시로 로그아웃 알림창으로 구현
            presentAlertView(.logout)
        } else {
            presentAlertView(.login)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfEvents
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        
        let event = viewModel.infoOfEvent(indexPath.row)
        cell.setUI(event)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventDetailViewController = EventDetailViewController()
        let event = viewModel.events[indexPath.row]
        eventDetailViewController.id = event.id
        
        self.navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
}
