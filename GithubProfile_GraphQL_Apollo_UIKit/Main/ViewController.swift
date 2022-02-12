//
//  ViewController.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/06.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

extension Notification.Name {
    static let githubUser = Notification.Name("github_user")
}

class ViewController: UIViewController {
    
    private var cancellable: AnyCancellable?
    
    let githubUserPublisher = NotificationCenter
        .Publisher(center: .default, name: .githubUser, object: nil)
        .map { notification -> String? in
            guard let user = notification.object as? UserProfileQuery.Data.User else { return nil }
            return user.email
        }
    
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
                
                NotificationCenter.default.post(name: .githubUser, object: userProfile)
                DispatchQueue.main.async {
                    sself.profileImageView.kf.setImage(with: urlImage)
                    sself.bioLabel.text = userProfile.bio
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        cancellable = githubUserPublisher
            .assign(to: \.text, on: emailLabel)
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
