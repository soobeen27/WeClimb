//
//  String+Extension.swift
//  WeClimb
//
//  Created by 머성이 on 12/3/24.
//

import UIKit

extension String {
    var colorInfo: (text: String, englishText: String, color: UIColor) {
        switch self {
        case "빨", "Red":
            return ("빨강", "Red", UIColor(red: 224/255, green: 53/255, blue: 53/255, alpha: 1))
        case "주", "Orange":
            return ("주황", "Orange", UIColor(red: 253/255, green: 150/255, blue: 68/255, alpha: 1))
        case "노", "Yellow":
            return ("노랑", "Yellow", UIColor(red: 255/255, green: 235/255, blue: 26/255, alpha: 1))
        case "연", "LightGreen":
            return ("연두", "LightGreen", UIColor(red: 30/255, green: 212/255, blue: 90/255, alpha: 1))
        case "초", "Green":
            return ("초록", "Green", UIColor(red: 26/255, green: 120/255, blue: 14/255, alpha: 1))
        case "하", "SkyBlue":
            return ("하늘", "SkyBlue", UIColor(red: 19/255, green: 149/255, blue: 255/255, alpha: 1))
        case "파", "Blue":
            return ("파랑", "Blue", UIColor(red: 35/255, green: 97/255, blue: 243/255, alpha: 1))
        case "남", "Indigo":
            return ("남색", "Indigo", UIColor(red: 15/255, green: 0/255, blue: 177/255, alpha: 1))
        case "보", "Purple":
            return ("보라", "Purple", UIColor(red: 160/255, green: 83/255, blue: 233/255, alpha: 1))
        case "검", "Black":
            return ("검정", "Black", UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        case "흰", "White":
            return ("흰색", "White", UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1))
        case "민", "Mint":
            return ("민트", "Mint", UIColor(red: 31/255, green: 223/255, blue: 213/255, alpha: 1))
        case "회", "Gray":
            return ("회색", "Gray", UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        case "핑", "Pink":
            return ("핑크", "Pink", UIColor(red: 255/255, green: 88/255, blue: 188/255, alpha: 1))
        case "갈", "Brown":
            return ("갈색", "Brown", UIColor(red: 187/255, green: 120/255, blue: 58/255, alpha: 1))
        case "노검", "DarkYellow":
            return ("노랑", "DarkYellow", UIColor(red: 133/255, green: 125/255, blue: 23/255, alpha: 1))
        case "초검", "DarkGreen":
            return ("초록", "DarkGreen", UIColor(red: 21/255, green: 114/255, blue: 55/255, alpha: 1))
        case "파검", "DarkBlue":
            return ("파랑", "DarkBlue", UIColor(red: 6/255, green: 103/255, blue: 121/255, alpha: 1))
        case "검빨", "DarkRed":
            return ("검정빨강", "DarkRed", UIColor(red: 122/255, green: 0/255, blue: 0/255, alpha: 1))
        case "B1":
            return ("B1", "B1", UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1))
        case "B2":
            return ("B2", "B2", UIColor(red: 255/255, green: 235/255, blue: 26/255, alpha: 1))
        case "B3":
            return ("B3", "B3", UIColor(red: 253/255, green: 150/255, blue: 68/255, alpha: 1))
        case "B4":
            return ("B4", "B4", UIColor(red: 26/255, green: 120/255, blue: 14/255, alpha: 1))
        case "B5":
            return ("B5", "B5", UIColor(red: 35/255, green: 97/255, blue: 243/255, alpha: 1))
        case "B6":
            return ("B6", "B6", UIColor(red: 224/255, green: 53/255, blue: 53/255, alpha: 1))
        case "B7":
            return ("B7", "B7", UIColor(red: 160/255, green: 83/255, blue: 233/255, alpha: 1))
        case "B8":
            return ("B8", "B8", UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1))
        case "B9":
            return ("B9", "B9", UIColor(red: 187/255, green: 120/255, blue: 58/255, alpha: 1))
        case "별":
            return ("Star", "Star", UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1))
        default:
            return (self, "Other", UIColor.clear)
        }
    }
    
    //extension String {
    //    var colorInfo: (text: String, englishText: String, image: UIImage?) {
    //        switch self {
    //        case "빨", "Red":
    //            return ("빨강", "Red", UIImage(systemName: "colorRed"))
    //        case "주", "Orange":
    //            return ("주황", "Orange", UIImage(systemName: "colorOrange"))
    //        case "노", "Yellow":
    //            return ("노랑", "Yellow", UIImage(systemName: "colorYellow"))
    //        case "연", "LightGreen":
    //            return ("연두", "LightGreen", UIImage(systemName: "colorLightGreen"))
    //        case "초", "Green":
    //            return ("초록", "Green", UIImage(systemName: "colorGreen"))
    //        case "하", "SkyBlue":
    //            return ("하늘", "SkyBlue", UIImage(systemName: "colorBlue"))
    //        case "파", "Blue":
    //            return ("파랑", "Blue", UIImage(systemName: "colorBlue"))
    //        case "남", "Navy":
    //            return ("남색", "Navy", UIImage(systemName: "colorNavy"))
    //        case "보", "Purple":
    //            return ("보라", "Purple", UIImage(systemName: "colorPurple"))
    //        case "검", "Black":
    //            return ("검정", "Black", UIImage(systemName: "colorBlack"))
    //        case "흰", "White":
    //            return ("흰색", "White", UIImage(systemName: "colorWhite"))
    //        case "민", "Mint":
    //            return ("민트", "Mint", UIImage(systemName: "colorMint"))
    //        case "회", "Gray":
    //            return ("회색", "Gray", UIImage(systemName: "colorGray"))
    //        case "핑", "Pink":
    //            return ("핑크", "Pink", UIImage(systemName: "colorPink"))
    //        case "갈", "Brown":
    //            return ("갈색", "Brown", UIImage(systemName: "colorBrown"))
    //        case "노검", "DarkYellow":
    //            return ("노랑", "DarkYellow", UIImage(systemName: "colorDarkYellow"))
    //        case "초검", "DarkGreen":
    //            return ("초록", "DarkGreen", UIImage(systemName: "colorDarkGreen"))
    //        case "파검", "DarkBlue":
    //            return ("파랑", "DarkBlue", UIImage(systemName: "colorDarkBlue"))
    //        case "검빨", "DarkRed":
    //            return ("검정빨강", "DarkRed", UIImage(systemName: "colorDarkRed"))
    //        case "B1":
    //            return ("B1", "B1", UIImage(systemName: "gradeB1"))
    //        case "B2":
    //            return ("B2", "B2", UIImage(systemName: "gradeB2"))
    //        case "B3":
    //            return ("B3", "B3", UIImage(systemName: "gradeB3"))
    //        case "B4":
    //            return ("B4", "B4", UIImage(systemName: "gradeB4"))
    //        case "B5":
    //            return ("B5", "B5", UIImage(systemName: "gradeB5"))
    //        case "B6":
    //            return ("B6", "B6", UIImage(systemName: "gradeB6"))
    //        case "B7":
    //            return ("B7", "B7",  UIImage(systemName: "gradeB7"))
    //        case "B8":
    //            return ("B8", "B8", UIImage(systemName: "gradeB8"))
    //        case "B9":
    //            return ("B9", "B9", UIImage(systemName: "gradeB9"))
    //        case "별":
    //            return ("Star", "Star", nil)
    //        default:
    //            return (self, "Other", nil)
    //        }
    //    }
    
    var getGradeArray: [String] {
        return self.components(separatedBy: ", ")
    }
    
    func colorTextChange() -> String {
        let colorMap: [String: String] = [
            "빨": "빨강",
            "주": "주황",
            "노": "노랑",
            "연": "연두",
            "초": "초록",
            "하": "하늘",
            "파": "파랑",
            "남": "남색",
            "보": "보라",
            "검": "검정",
            "흰": "흰색",
            "민": "민트",
            "회": "회색",
            "핑": "핑크",
            "갈": "갈색",
            "노검": "노랑검정",
            "초검": "초록검정",
            "파검": "파랑검정",
        ]
        return colorMap[self] ?? self
    }
    
    func imageTextChange() -> String {
        let colorMap: [String: String] = [
            "빨": "colorRed",
            "주": "colorOrange",
            "노": "colorYellow",
            "연": "colorLightGreen",
            "초": "colorGreen",
            "하": "colorMint",
            "파": "colorBlue",
            "남": "colorNavy",
            "보": "colorPurple",
            "검": "colorBlack",
            "흰": "colorWhite",
            "민": "colorMint",
            "회": "colorGray",
            "핑": "colorPink",
            "갈": "colorBrown",
            "노검": "colorDarkYellow",
            "초검": "colorDarkGreen",
            "파검": "colorDarkBlue",
            "기타": "colorDarkGreen"
        ]
        return colorMap[self] ?? self
    }
}
