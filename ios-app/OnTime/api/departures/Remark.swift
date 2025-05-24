//
//  Remark.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 20.05.25.
//

import Foundation

enum RemarkType: String, Codable {
    case warning
    case status
    case hint
}

protocol Remark: Codable, Identifiable {
    var id: String { get }
    var type: RemarkType { get }
    var text: String? { get }
}

struct WarningRemarkIcon: Codable {
    let type: String
    let title: String?
}

struct WarningRemark: Remark {
    let id: String
    var type: RemarkType = .warning
    let summary: String?
    let text: String?
    let priority: Int16?
    let products: Products?
    let validFrom: Date?
    let validUntil: Date?
    let icon: WarningRemarkIcon?
}

struct StatusRemark: Remark {
    let id = generateNanoId(size: 4)
    var type: RemarkType = .status
    let code: String?
    let text: String?
}

struct HintRemark: Remark {
    let id = generateNanoId(size: 4)
    var type: RemarkType = .hint
    let code: String?
    let text: String?
}

// a wrapper to use this for decoding/encoding
enum AnyRemark: Remark {
    
    case warning(WarningRemark)
    case status(StatusRemark)
    case hint(HintRemark)
    
    private var base: any Remark {
        switch self {
        case .warning(let r): return r
        case .status(let r): return r
        case .hint(let r): return r
        }
    }
    
    var id: String { base.id }
    var type: RemarkType { base.type }
    var text: String? { base.text }

    enum CodingKeys: String, CodingKey { case type }
    
    init(from decoder: Decoder) throws {
        // look only at the "type" field
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(RemarkType.self, forKey: .type)

        // let the appropriate struct decode itself
        switch kind {
        case .warning:
            self = .warning(try WarningRemark(from: decoder))
        case .status:
            self = .status(try StatusRemark(from: decoder))
        case .hint:
            self = .hint(try HintRemark(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .warning(let value):
            try container.encode(value)
        case .status(let value):
            try container.encode(value)
        case .hint(let value):
            try container.encode(value)
        }
    }
}

extension Array where Element == any Remark {
    func toAnyRemarks() -> [AnyRemark] {
        compactMap { remark in
            if let warning = remark as? WarningRemark {
                return .warning(warning)
            } else if let status = remark as? StatusRemark {
                return .status(status)
            } else if let hint = remark as? HintRemark {
                return .hint(hint)
            } else {
                return nil
            }
        }
    }
}
