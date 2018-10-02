// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "RxReusable",
  products: [
    .library(name: "RxReusable", targets: ["RxReusable"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/devxoul/RxExpect.git", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    .target(name: "RxReusable", dependencies: ["RxSwift", "RxCocoa"]),
    .testTarget(name: "RxReusableTests", dependencies: ["RxReusable", "RxExpect"]),
  ]
)
