//
//  AssetsPhotoViewController+Selection.swift
//  AssetsPickerViewController
//
//  Created by DragonCherry on 2020/07/03.
//

import UIKit
import Photos


// MARK: - UICollectionViewDelegate
extension AssetsPhotoViewController: UICollectionViewDelegate {
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if LogConfig.isSelectLogEnabled { logi("shouldSelectItemAt: \(indexPath.row)") }
        if let delegate = self.delegate {
            let shouldSelect = delegate.assetsPicker?(controller: picker, shouldSelect: AssetsManager.shared.assetArray[indexPath.row], at: indexPath) ?? true
            guard shouldSelect else { return false }
        }
        deselectOldestIfNeeded()
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if LogConfig.isSelectLogEnabled { logi("didSelectItemAt: \(indexPath.row)") }
        deselectOldestIfNeeded()
        select(at: indexPath)
        selectCell(at: indexPath)
        updateSelectionCount()
        updateNavigationStatus()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if LogConfig.isSelectLogEnabled { logi("shouldDeselectItemAt: \(indexPath.row)") }
        if let delegate = self.delegate {
            let shouldDeselect = delegate.assetsPicker?(controller: picker, shouldDeselect: AssetsManager.shared.assetArray[indexPath.row], at: indexPath) ?? true
            guard shouldDeselect else { return false }
        }
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if LogConfig.isSelectLogEnabled { logi("didDeselectItemAt: \(indexPath.row)") }
        deselect(at: indexPath)
        deselectCell(at: indexPath)
        updateSelectionCount()
        updateNavigationStatus()
    }
}

extension AssetsPhotoViewController {
    func checkInconsistencyForSelection() {
        guard LogConfig.isSelectLogEnabled else { return }
        if let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems, !indexPathsForSelectedItems.isEmpty {
            if selectedArray.count != indexPathsForSelectedItems.count || selectedMap.count != indexPathsForSelectedItems.count {
                loge("selected item count not matched!")
                return
            }
            for selectedIndexPath in indexPathsForSelectedItems {
                if let _ = selectedMap[AssetsManager.shared.assetArray[selectedIndexPath.row].localIdentifier] {
                    
                } else {
                    loge("selected item not found in local map!")
                }
            }
        } else {
            if !selectedMap.isEmpty || !selectedArray.isEmpty {
                loge("selected items not matched!")
            }
        }
    }
}
