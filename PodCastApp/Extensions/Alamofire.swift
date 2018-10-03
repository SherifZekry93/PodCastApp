//
//  Connectivity.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/30/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
