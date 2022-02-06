//
//  ViewController.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/06.
//

import UIKit
import SnapKit
import Kingfisher

class ViewController: UIViewController {
    
    let stackView = UIStackView()
    
    let profileImageView = UIImageView()
    let emailLabel = UILabel()
    let bioLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        layout()
        
        GraphQLNetwork.shared.apollo.fetch(query: UserProfileQuery(username: "wjdgkals23")) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                guard let sself = self else { return }
                guard let userProfile = graphQLResult.data?.user else { return }
                guard let urlImage = URL(string: userProfile.avatarUrl) else { return }
                        
                DispatchQueue.main.async {
                    sself.profileImageView.kf.setImage(with: urlImage)
                    sself.emailLabel.text = userProfile.email
                    sself.bioLabel.text = userProfile.bio
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func layout() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubviews(views: [profileImageView, emailLabel, bioLabel])
        
        self.view.addSubview(stackView)
        
        profileImageView.contentMode = .scaleAspectFit
        emailLabel.textAlignment = .center
        bioLabel.textAlignment = .center
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
