//
//  LHColors.swift
//  WeClimb
//
//  Created by Soobeen Jang on 2/3/25.
//

import UIKit
enum LHColors {
    case black,
         blue,
         brown,
         darkBlue,
         darkGreen,
         darkRed,
         darkYellow,
         gray,
         green,
         lightGreen,
         mint,
         navy,
         orange,
         pink,
         purple,
         red,
         white,
         yellow,
         B1,
         B2,
         B3,
         B4,
         B5,
         B6,
         B7,
         B8,
         B9,
         etc,
         other

    private static let shortKorMap: [String: LHColors] = [
        "빨": .red,
        "주": .orange,
        "노": .yellow,
        "연": .lightGreen,
        "초": .green,

        "하": .mint,
        "파": .blue,
        "남": .navy,
        "보": .purple,
        "검": .black,
        
        "흰": .white,
        "민": .mint,
        "회": .gray,
        "핑": .pink,
        "갈": .brown,
        
        "빨검": .darkRed,
        "노검": .darkYellow,
        "초검": .darkGreen,
        "파검": .darkBlue,
        
        "B1": .B1,
        "B2": .B2,
        "B3": .B3,
        "B4": .B4,
        "B5": .B5,
        "B6": .B6,
        "B7": .B7,
        "B8": .B8,
        "B9": .B9,
        
        "기타": .etc
    ]

    private static let engMap: [String: LHColors] = [
        "Black": .black,
        "Blue": .blue,
        "Brown": .brown,
        
        "DarkBlue": .darkBlue,
        "DarkGreen": .darkGreen,
        "DarkRed": .darkRed,
        "DarkYellow": .darkYellow,
        
        "Gray": .gray,
        "Green": .green,
        "LightGreen": .lightGreen,
        "Mint": .mint,
        
        "Navy": .navy,
        "Orange": .orange,
        "Pink": .pink,
        "Purple": .purple,
        
        "Red": .red,
        "White": .white,
        "Yellow": .yellow,
        
        "B1": .B1,
        "B2": .B2,
        "B3": .B3,
        "B4": .B4,
        "B5": .B5,
        "B6": .B6,
        "B7": .B7,
        "B8": .B8,
        "B9": .B9
    ]

    private static let holdEngMap: [String: LHColors] = Dictionary(
        uniqueKeysWithValues: engMap.map { ("hold" + $0.key.capitalized, $0.value) }
    )

    private static let koreanNames: [LHColors: String] = [
        .black: "검정",
        .blue: "파랑",
        .brown: "갈색",
        
        .darkBlue: "파랑검정",
        .darkGreen: "초록검정",
        .darkRed: "빨강검정",
        .darkYellow: "노랑검정",
        
        .gray: "회색",
        .green: "초록",
        .lightGreen: "연두",
        .mint: "민트",
        
        .navy: "남색",
        .orange: "주황",
        .pink: "핑크",
        .purple: "보라",
        
        .red: "빨강",
        .white: "흰색",
        .yellow: "노랑",
        .other: "기타",
        
        .B1: "B1",
        .B2: "B2",
        .B3: "B3",
        .B4: "B4",
        .B5: "B5",
        .B6: "B6",
        .B7: "B7",
        .B8: "B8",
        .B9: "B9"
    ]

    private static let images: [LHColors: UIImage] = [
        .black: UIImage.colorBlack,
        .blue: UIImage.colorBlue,
        .brown: UIImage.colorBrown,
        
        .darkBlue: UIImage.colorDarkBlue,
        .darkGreen: UIImage.colorDarkGreen,
        .darkRed: UIImage.colorDarkRed,
        .darkYellow: UIImage.colorDarkYellow,
        
        .gray: UIImage.colorGray,
        .green: UIImage.colorGreen,
        .lightGreen: UIImage.colorLightGreen,
        
        .mint: UIImage.colorMint,
        .navy: UIImage.colorNavy,
        .orange: UIImage.colorOrange,
        
        .pink: UIImage.colorPink,
        .purple: UIImage.colorPurple,
        .red: UIImage.colorRed,
        
        .white: UIImage.colorWhite,
        .yellow: UIImage.colorYellow,
        
        .B1:UIImage.gradeB1,
        .B2:UIImage.gradeB2,
        .B3:UIImage.gradeB3,
        .B4:UIImage.gradeB4,
        .B5:UIImage.gradeB5,
        .B6:UIImage.gradeB6,
        .B7:UIImage.gradeB7,
        .B8:UIImage.gradeB8,
        .B9:UIImage.gradeB9,
        
        .etc: UIImage.colorDarkGreen,
        .other: UIImage.closeIconCircle,
    ]
    
    private static let backgroundGrade: [LHColors: UIColor] = [
        .B1: UIColor.accentBlack,
        .B2: UIColor.accentBlack,
        .B3: UIColor.accentBlack,
        .B4: UIColor.accentBlack,
        .B5: UIColor.accentBlack,
        .B6: UIColor.accentBlack,
        .B7: UIColor.accentBlack,
        .B8: UIColor.accentBlack,
        .B9: UIColor.accentBlack,
        .black: UIColor.accentBlack,
        
        .red: UIColor.accentRed,
        .darkRed: UIColor.accentRed,
        
        .blue: UIColor.accentBlue,
        .darkBlue: UIColor.accentBlue,
        .navy: UIColor.accentBlue,
        
        .green: UIColor.accentGreen,
        .lightGreen: UIColor.accentLigthGreen,
        .darkGreen: UIColor.accentGreen,
        .mint: UIColor.accentMint,
        
        .yellow: UIColor.accentYellow,
        .darkYellow: UIColor.accentYellow,
        .orange: UIColor.accentOrange,
        
        .purple: UIColor.accentPurple,
        .pink: UIColor.accentPink,
        
        .brown: UIColor.accentBrown,
        
        .gray: UIColor.accentGray,
        
        .white: UIColor.accentWhite,
        
        .other: UIColor.clear
    ]

    private static let gradeFontColor: [LHColors: UIColor] = [
        .black: UIColor.labelNeutral,
        .blue: UIColor.gradeBlue,
        .brown: UIColor.gradeBrown,
        
        .darkBlue: UIColor.gradeBlue,
        .darkGreen: UIColor.gradeGreen,
        .darkRed: UIColor.gradeRed,
        .darkYellow: UIColor.gradeYellow,
        
        .gray: UIColor.gradeGray,
        .green: UIColor.gradeGreen,
        .lightGreen: UIColor.gradeLightGreen,
        
        .mint: UIColor.gradeMint,
        .navy: UIColor.gradeNavy,
        .orange: UIColor.gradeOrange,
        
        .pink: UIColor.gradePink,
        .purple: UIColor.gradePurple,
        .red: UIColor.gradeRed,
        
        .white: UIColor.gradeWhite,
        .yellow: UIColor.gradeYellow,
        
        .B1: UIColor.gradeBlack,
        .B2: UIColor.gradeBlack,
        .B3: UIColor.gradeBlack,
        .B4: UIColor.gradeBlack,
        .B5: UIColor.gradeBlack,
        .B6: UIColor.gradeBlack,
        .B7: UIColor.gradeBlack,
        .B8: UIColor.gradeBlack,
        .B9: UIColor.gradeBlack,
        
        .other: UIColor.gray
    ]
    
    private static let imageString: [LHColors: String] = [
        .black: "colorBlack", .blue: "colorBlue", .brown: "colorBrown",
        .darkBlue: "colorDarkBlue", .darkGreen: "colorDarkGreen", .darkRed: "colorDarkRed",
        .darkYellow: "colorDarkYellow", .gray: "colorGray", .green: "colorGreen",
        .lightGreen: "colorLightGreen", .mint: "colorMint", .navy: "colorNavy",
        .orange: "colorOrange", .pink: "colorPink", .purple: "colorPurple",
        .red: "colorRed", .white: "colorWhite", .yellow: "colorYellow",
        .B1: "gradeB1", .B2: "gradeB2", .B3: "gradeB3", .B4: "gradeB4",
        .B5: "gradeB5", .B6: "gradeB6", .B7: "gradeB7", .B8: "gradeB8",
        .B9: "gradeB9", .other: "colorDarkGreen"
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
    
    static func fromKoreanFull(_ string: String) -> LHColors {
        return LHColors.koreanNames.first(where: { $0.value == string })?.key ?? .other
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
    
    func toImageString() -> String {
        return LHColors.imageString[self] ?? "colorDefault"
    }
    
    func toBackgroundAccent() -> UIColor {
        return LHColors.backgroundGrade[self] ?? UIColor.clear
    }
    
    func toFontColor() -> UIColor {
        return LHColors.gradeFontColor[self] ?? UIColor.black
    }
}

