// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UserProfileQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query UserProfile($username: String!) {
      user(login: $username) {
        __typename
        email
        avatarUrl
        bio
        websiteUrl
      }
    }
    """

  public let operationName: String = "UserProfile"

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var variables: GraphQLMap? {
    return ["username": username]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("user", arguments: ["login": GraphQLVariable("username")], type: .object(User.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(user: User? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
    }

    /// Lookup a user by login.
    public var user: User? {
      get {
        return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "user")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
          GraphQLField("bio", type: .scalar(String.self)),
          GraphQLField("websiteUrl", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(email: String, avatarUrl: String, bio: String? = nil, websiteUrl: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "email": email, "avatarUrl": avatarUrl, "bio": bio, "websiteUrl": websiteUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The user's publicly visible profile email.
      public var email: String {
        get {
          return resultMap["email"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      /// A URL pointing to the user's public avatar.
      public var avatarUrl: String {
        get {
          return resultMap["avatarUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "avatarUrl")
        }
      }

      /// The user's public profile bio.
      public var bio: String? {
        get {
          return resultMap["bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      /// A URL pointing to the user's public website/blog.
      public var websiteUrl: String? {
        get {
          return resultMap["websiteUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "websiteUrl")
        }
      }
    }
  }
}
