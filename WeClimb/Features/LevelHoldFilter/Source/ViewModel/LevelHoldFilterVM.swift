//
//  LevelHoldFilterVM.swift
//  WeClimb
//
//  Created by 강유정 on 1/8/25.
//

import RxSwift
import RxCocoa

protocol LevelHoldFilterVM {
    func transform(input: LevelHoldFilterVMImpl.Input) -> LevelHoldFilterVMImpl.Output
}

class LevelHoldFilterVMImpl: LevelHoldFilterVM {

    struct Input {
        let gymName: String
        let segmentedControlSelection: Observable<Int>
        let cellSelection: Observable<(text: String, image: String, isChecked: Bool)>
        let applyButtonTap: Observable<Void>
    }

    struct Output {
        let cellData: Observable<[(text: String, image: String, isChecked: Bool)]>
        let appliedFilters: Observable<(level: [String], hold: [String])>
        let selectedItems: Observable<[Int]>
    }

    private let gymUseCase: GymUseCase
    private var gym: Gym?

    private var selectedLevelItems = BehaviorSubject<[Int]>(value: [])
    private var selectedHoldItems = BehaviorSubject<[Int]>(value: [])
    
    private var selectedSegmentIndex = BehaviorSubject<Int>(value: 0)
    
    private let selectedItems = BehaviorSubject<[Int]>(value: [])

    private let disposeBag = DisposeBag()

    init(gymUseCase: GymUseCase) {
        self.gymUseCase = gymUseCase
    }

    func transform(input: Input) -> Output {
        let cellData = BehaviorSubject(value: [(text: String, image: String, isChecked: Bool)]())
        let appliedFilters = PublishSubject<(level: [String], hold: [String])>()

        fetchGymData(gymName: input.gymName) { [weak self] in
            guard let self = self else { return }
            self.updateLevelData(cellData: cellData)
        }

        input.segmentedControlSelection
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.selectedSegmentIndex.onNext(index)
                
                if index == 0 {
                    self.updateLevelData(cellData: cellData)
                } else {
                    self.updateHoldData(cellData: cellData)
                }
            })
            .disposed(by: disposeBag)

        input.cellSelection
            .subscribe(onNext: { [weak self] item in
                self?.toggleSelection(item: item, cellData: cellData)
            })
            .disposed(by: disposeBag)

        input.applyButtonTap
            .subscribe(onNext: { [weak self] in
                self?.applyFilters(appliedFilters: appliedFilters)
            })
            .disposed(by: disposeBag)
        
        return Output(
            cellData: cellData.asObservable(),
            appliedFilters: appliedFilters.asObservable(),
            selectedItems: Observable.merge(
                selectedLevelItems.asObservable(),
                selectedHoldItems.asObservable()
            )
        )
    }

    private func fetchGymData(gymName: String, completion: @escaping () -> Void) {
        gymUseCase.gymInfo(gymName: gymName)
            .subscribe(onSuccess: { [weak self] gym in
                self?.gym = gym
                completion()
            }, onFailure: { error in
                print("데이터를 가져오지 못함: \(error)")
            })
            .disposed(by: disposeBag)
    }

    private func updateLevelData(cellData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>) {
        guard let gym = gym else { return }

        let levelData = gym.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        print("Level data: \(levelData)")

        var levelTextImageData = levelData.map { (text: $0.colorTextChange(), image: $0.imageTextChange(), isChecked: false) }

        if let selectedIndexes = try? selectedLevelItems.value() {
            for index in selectedIndexes {
                if index < levelTextImageData.count {
                    levelTextImageData[index].isChecked = true
                }
            }
        }
       
        cellData.onNext(levelTextImageData)
    }

    private func updateHoldData(cellData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>) {
        var holdTextImageData = Hold.allCases.map { (text: $0.koreanHold, image: $0.imageName, isChecked: false) }
        print("Hold data: \(holdTextImageData)")

        if let selectedIndexes = try? selectedHoldItems.value() {
            for index in selectedIndexes {
                if index < holdTextImageData.count {
                    holdTextImageData[index].isChecked = true
                }
            }
        }
 

        cellData.onNext(holdTextImageData)
    }

    private func toggleSelection(item: (text: String, image: String, isChecked: Bool), cellData: BehaviorSubject<[(text: String, image: String, isChecked: Bool)]>) {
        var currentItems = (try? cellData.value()) ?? []

        if let index = currentItems.firstIndex(where: { $0.text == item.text }) {
            
            if currentItems[index].isChecked {
                currentItems[index].isChecked = false
            } else {
                currentItems = currentItems.map { item in
                    var updatedItem = item
                    updatedItem.isChecked = false
                    return updatedItem
                }
                currentItems[index].isChecked = true
            }


            let selectedIndexes = currentItems.indices.filter { currentItems[$0].isChecked }

            if let segmentedIndex = try? selectedSegmentIndex.value(), segmentedIndex == 0 {
                selectedLevelItems.onNext(selectedIndexes)
            } else {
                selectedHoldItems.onNext(selectedIndexes)
            }

            cellData.onNext(currentItems)
        }
       
    }

    private func applyFilters(appliedFilters: PublishSubject<(level: [String], hold: [String])>) {
        let levelFilters = try? selectedLevelItems.value().map { gym?.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }[$0].colorTextChange() ?? "" }
        let holdFilters = try? selectedHoldItems.value().map { Hold.allCases[$0].koreanHold }

        appliedFilters.onNext((
            level: levelFilters ?? [],
            hold: holdFilters ?? []
        ))
    }
}
