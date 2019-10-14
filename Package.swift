// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  AMSpeedMeter, https://github.com/adventam10/AMSpeedMeter
//
//  Created by am10 on 2017/12/29.
//  Copyright © 2017年 am10. All rights reserved.
//

import PackageDescription

let package = Package(name: "AMSpeedMeter",
                      platforms: [.iOS(.v9)],
                      products: [.library(name: "AMSpeedMeter",
                                          targets: ["AMSpeedMeter"])],
                      targets: [.target(name: "AMSpeedMeter",
                                        path: "Source")],
                      swiftLanguageVersions: [.v5])
