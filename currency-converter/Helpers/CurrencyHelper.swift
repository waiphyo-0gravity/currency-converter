//
//  CurrencyMapper.swift
//  currency-converter
//
//  Created by Wai Phyo on 8/6/21.
//

import Foundation

//enum CurrencyMapper: String {
//    case aed = "AED", afn = "AFN", all = "ALL", amd = "AMD", ang = "ANG", aoa = "AOA", ars = "ARS", aud = "AUD", awg = "AWG", azn = "AZN", bam = "BAM", bbd = "BBD", bdt = "BDT", bgn = "BGN", bhd = "BHD", bif = "BIF"
//
//    var symbol: String? {
//        switch self {
//        case .aed:
//            return "د.إ"
//        case .afn:
//            return "Af"
//        case .all:
//            return "L"
//        case .amd:
//            return "Դ"
//        case .ang:
//            return "NAƒ"
//        case .aoa:
//            return "Kz"
//        case .ars:
//            return "$"
//        case .aud:
//            return "$"
//        case .awg:
//            return "ƒ"
//        case .azn:
//            return "ман"
//        case .bam:
//            return "ман"
//        case .bbd:
//            return "$"
//        case .bdt:
//            return "৳"
//        case .bgn:
//            return "лв"
//        case .bhd:
//            return "ب.د"
//        case .bif:
//            return "₣"
//        }
//    }
//
//    var name: String? {
//        switch self {
//        case .aed:
//            return "UAE Dirham"
//        case .afn:
//            return "Afghani"
//        case .all:
//            return "Lek"
//        case .amd:
//            return "Armenian Dram"
//        case .ang:
//            return "Netherlands Antillean guilder"
//        case .aoa:
//            return "Kwanza"
//        case .ars:
//            return "Argentine Peso"
//        case .aud:
//            return "Australian Dollar"
//        case .awg:
//            return "Aruban Guilder/Florin"
//        case .azn:
//            return "Azerbaijanian Manat"
//        case .bam:
//            return "Azerbaijanian Manat"
//        case .bbd:
//            return "Barbados Dollar"
//        case .bdt:
//            return "Taka"
//        case .bgn:
//            return "Bulgarian Lev"
//        case .bhd:
//            return "Bahraini Dinar"
//        case .bif:
//            return "Burundi Franc"
//        }
//    }
//
//    static func getSymbol(forCurrencyCode code: String) -> String? {
//        let locale = NSLocale(localeIdentifier: code)
//        if locale.displayName(forKey: .currencySymbol, value: code) == code {
//            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
//            return newlocale.displayName(forKey: .currencySymbol, value: code)
//        }
//
//        return locale.displayName(forKey: .currencySymbol, value: code)
//    }
//}
//
//extension Locale {
//    func localizedCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
//        guard let languageCode = languageCode, let regionCode = regionCode else { return nil }
//
//        /*
//         Each currency can have a symbol ($, £, ¥),
//         but those symbols may be shared with other currencies.
//         For example, in Canadian and American locales,
//         the $ symbol on its own implicitly represents CAD and USD, respectively.
//         Including the language and region here ensures that
//         USD is represented as $ in America and US$ in Canada.
//        */
//        let components: [String: String] = [
//            NSLocale.Key.languageCode.rawValue: languageCode,
//            NSLocale.Key.countryCode.rawValue: regionCode,
//            NSLocale.Key.currencyCode.rawValue: currencyCode,
//        ]
//
//        let identifier = Locale.identifier(fromComponents: components)
//
//        return Locale(identifier: identifier).currencySymbol
//    }
//}

class CurrencyHelper {
    static let instance: CurrencyHelper = {
        return CurrencyHelper()
    }()
    
    func getCurrencySymbol(forCurrencyCode currencyCode: String) -> String {
        return Locale.current.localizedCurrencySymbol(forCurrencyCode: currencyCode) ?? currencyCode
    }
    
    func getCurrencyName(forCurrencyCode currencyCode: String) -> String {
        return Locale.current.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
    }
    
    func changeFormat(for value: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    func trimSourceCurrencyCode(for code: String, source: String) -> String {
        let range = source.range(of: source)
        return code.replacingOccurrences(of: source, with: "", range: range)
    }
}
