//
//  ServiceProxy.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 1/2/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

/// Http client - asynchrnous api call
class Services: NSObject {
    static let shared = Services()
    private let kBaseURL = "https://api.instagram.com/v1"
    private let accessToken = "5956152420.6d6cef1.80211b1480af4b74a11d239e091c83ed"
    private lazy var servicesProxy: ServicesProxy = {
        return ServicesProxy(baseURL: self.kBaseURL,
                             presetParams: ["access_token": self.accessToken])
    }()

    // MARK: - GET

    func fetchComments(feedId: String,
                       params: [AnyHashable: Any]? = nil,
                          success: @escaping ([Comment]) -> Void,
                          failure: @escaping (Error) -> Void) {
        servicesProxy.fetchModel("/media/\(feedId)/comments/",
                                      params: params,
                                      success: success,
                                      failure: failure)
    }

    func fetchRecentMedia(params: [AnyHashable: Any]? = nil,
                          success: @escaping ([Feed]) -> Void,
                          failure: @escaping (Error) -> Void,
                          cached: (([Feed]) -> Void)? = nil) {
        servicesProxy.fetchModel("/users/5956152420/media/recent/",
                                      params: params,
                                      success: success,
                                      failure: failure,
                                      cached: cached)
    }

    func fetchLikedMedia(success: @escaping ([Feed]) -> Void, failure: @escaping (Error) -> Void) {
        servicesProxy.fetchModel("/users/self/media/liked/", success: success, failure: failure)
    }

    func fetchFollows(success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        servicesProxy.fetchModel("/users/self/follows/", success: success, failure: failure)
    }

    func fetchFollowers(success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        servicesProxy.fetchModel("/users/self/followed-by/", success: success, failure: failure)
    }

    func fetchLikeUsers(feedId: String, success: @escaping ([User]) -> Void, failure: @escaping (Error) -> Void) {
        servicesProxy.fetchModel("/media/\(feedId)/likes/", success: success, failure: failure)
    }

    // MARK: - POST
    func likeFeed(feedId: String,
                  success: @escaping (Any?) -> Void,
                  failure: @escaping (Error) -> Void) {
        servicesProxy.postData("/media/\(feedId)/likes/",
            success: { (task, data) in
                success(data)
        }, failure: {(task, error) in
            fatalError()
        })
    }

    // MARK: - DEL
    func unlikeFeed(feedId: String,
                    success: @escaping (Any?) -> Void,
                    failure: @escaping (Error) -> Void) {
        let endPoint = "/media/\(feedId)/likes/"
        servicesProxy.deleteData(endPoint,
            success: { (task, data) in
                success(data)
        }, failure: {(task, error) in
            fatalError()
        })
    }
}




