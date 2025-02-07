//
//  LHColors.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/3/25.
//

import UIKit
enum LHColors {
    case black, blue, brown, darkBlue, darkGreen, darkRed, darkYellow, gray, green, lightGreen, mint, navy, orange, pink, purple, red, white, yellow, other

    private static let shortKorMap: [String: LHColors] = [
        "빨": .red, "주": .orange, "노": .yellow, "연": .lightGreen, "초": .green,
        "하": .mint, "파": .blue, "남": .navy, "보": .purple, "검": .black,
        "흰": .white, "민": .mint, "회": .gray, "핑": .pink, "갈": .brown,
        "노검": .darkYellow, "초검": .darkGreen, "파검": .darkBlue
    ]

    private static let engMap: [String: LHColors] = [
        "Black": .black, "Blue": .blue, "Brown": .brown, "DarkBlue": .darkBlue,
        "DarkGreen": .darkGreen, "DarkRed": .darkRed, "DarkYellow": .darkYellow,
        "Gray": .gray, "Green": .green, "LightGreen": .lightGreen, "Mint": .mint,
        "Navy": .navy, "Orange": .orange, "Pink": .pink, "Purple": .purple,
        "Red": .red, "White": .white, "Yellow": .yellow
    ]

    private static let holdEngMap: [String: LHColors] = Dictionary(
        uniqueKeysWithValues: engMap.map { ("hold" + $0.key.capitalized, $0.value) }
    )

    private static let koreanNames: [LHColors: String] = [
        .black: "검정", .blue: "파랑", .brown: "갈색", .darkBlue: "파랑검정",
        .darkGreen: "초록검정", .darkRed: "빨강검정", .darkYellow: "노랑검정",
        .gray: "회색", .green: "초록", .lightGreen: "연두", .mint: "민트",
        .navy: "남색", .orange: "주황", .pink: "핑크", .purple: "보라",
        .red: "빨강", .white: "흰색", .yellow: "노랑", .other: "기타"
    ]

    private static let images: [LHColors: UIImage] = [
        .black: UIImage.colorBlack, .blue: UIImage.colorBlue, .brown: UIImage.colorBrown,
        .darkBlue: UIImage.colorDarkBlue, .darkGreen: UIImage.colorDarkGreen,
        .darkRed: UIImage.colorDarkRed, .darkYellow: UIImage.colorDarkYellow,
        .gray: UIImage.colorGray, .green: UIImage.colorGreen, .lightGreen: UIImage.colorLightGreen,
        .mint: UIImage.colorMint, .navy: UIImage.colorNavy, .orange: UIImage.colorOrange,
        .pink: UIImage.colorPink, .purple: UIImage.colorPurple, .red: UIImage.colorRed,
        .white: UIImage.colorWhite, .yellow: UIImage.colorYellow, .other: UIImage.closeIconCircle
    ]

    static func fromShortKor(_ string: String) -> LHColors {
        return shortKorMap[string] ?? .other
    }

    static func fromEng(_ string: String) -> LHColors {
        return engMap[string] ?? .other
    }

    static func fromHoldEng(_ string: String) -> LHColors {
        return holdEngMap[string] ?? .other
    }

    func toKorean() -> String {
        return LHColors.koreanNames[self] ?? "기타"
    }

    func toEng() -> String {
        return LHColors.engMap.first { $0.value == self }?.key ?? "other"
    }

    func toHoldEng() -> String {
        return "hold" + toEng().capitalized
    }

    func toImage() -> UIImage {
        return LHColors.images[self] ?? UIImage.closeIconCircle
    }
}

