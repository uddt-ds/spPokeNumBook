//
//  CustomError.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/21/25.
//

import Foundation

enum CustomError: Error {
    case wrongUrl
    case requestFail
    case dataError
    case responseFail
    case decodingError
    case mustInput
    case mustImage

    var errorTitle: String {
        switch self {
        case .wrongUrl:
            return "URL 또는 URL 형식이 잘못되었습니다."
        case .requestFail:
            return "요청에 실패하였습니다."
        case .dataError:
            return "데이터가 없습니다."
        case .responseFail:
            return "응답에 실패하였습니다."
        case .decodingError:
            return "데이터 디코딩에 실패하였습니다."
        case .mustInput:
            return "이름과 전화번호를 입력해주세요"
        case .mustImage:
            return "랜덤 이미지 생성으로 포켓몬을 잡아주세요"
        }
    }
}
