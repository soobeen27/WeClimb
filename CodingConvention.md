
## ⚠️ Force Unwrapping 금지 ⚠️

## 접근 제한자

다른곳에서 접근 필요 x → private

## Raw Value

⚠️ View, ViewModel에 “ ” 금지

- enum 사용해서 NameSpace 파일에 넣기

```swift
// 선언 예시
enum SomeNameSpace {
    static let cellIdentifier = "cellIdent"
}

// 사용 예시
SomeNameSpace.cellIdentifier
```

## 약어

- ViewController = VC
- ViewModel = VM

## Method

- 레이아웃 설정부분 **setLayout** 함수명 사용
- cell 데이터 넣을때 **configure** 메소드를 사용하여 넣기

## Layout

- componets 선언후 클로저로 설정
- SnapKit 사용하여 오토레이아웃 설정

# 🍤 RxSwift

https://github.com/fimuxd/RxSwift?tab=readme-ov-file 필요시 공부

- 동기, 비동기 관련 (API)
- 데이터 바인딩
- UITableView, UICollectionView, UIButton

```swift
         items
             .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
             }
             .disposed(by: disposeBag)
```

.뭐시기 할 때 다음줄에서하기

## Extension

- 특정타입에서 여러번 반복되는 변환작업등 ex) extension String
```
    extension Int {
        var intToString {
            return String(self)
    }
```
