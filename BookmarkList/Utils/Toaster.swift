//
//  Toaster.swift
//  BookmarkList
//
//  Created by jc.kim on 3/13/21.
//

import Toaster

class Toaster {
    static func show() {
        let toast = Toast(text: "즐겨찾기가 추가되었습니다.", duration: 0.5)
        toast.view.font = UIFont.systemFont(ofSize: 17)
        toast.show()
    }
    
    static func remove() {
        let toast = Toast(text: "즐겨찾기가 삭제되었습니다.", duration: 0.5)
        toast.view.font = UIFont.systemFont(ofSize: 17)
        toast.show()
    }
}
