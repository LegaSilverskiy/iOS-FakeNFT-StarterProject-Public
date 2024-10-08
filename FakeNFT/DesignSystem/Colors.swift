import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // сюда добавляем цвета нужные для верстки
    // Ниже приведены примеры цветов, настоящие цвета надо взять из фигмы

    // Primary Colors
    static let primary = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)

    // Secondary Colors
    static let secondary = UIColor(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 1.0)

    // Background Colors
    static let background = UIColor.white

    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black
    static let yellowStar = UIColor(hexString: "#FEEF0D")
    static let redFavoriteButton = UIColor(hexString: "#FF3B30")
    static let yaYellow = UIColor(hexString: "#FEEF0D")
    static let yaGreen = UIColor(hexString: "#1C9F00")
    static let yaRed = UIColor(hexString: "#FF3B30")
    static let yaBlue = UIColor(hexString: "#0A84FF")

    // epic Statistics
    static let avatarStubTintColor = UIColor(hexString: "#625C5C")

    // epic Catalog
    static let blueColorForLinks = UIColor(hexString: "#0A84FF")
    static let blackForUI = UIColor(hexString: "#1A1B22")
    static let yelowForStars = UIColor(hexString: "#FEEF0D")
    static let pinkForLikeButton = UIColor(hexString: "#F56B6C")
    static let mainTextColor = UIColor(hexString: "#1A1B22")

    // epic Profile
    static let textFieldTintColor = UIColor(hexString: "#F7F7F8")
    static let likeTintColor = UIColor(hexString: "#F56B6C")

    // тут создаем константы для цветов с поддержкой темной темы
    static let tabBarItemsTintColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayDark
        : .yaLightGrayLight
    }

    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }

    // сюда помещаем цвета, используемые для создания констант, но не используемые в коде напрямую
    private static let yaBlackLight = UIColor(hexString: "1A1B22")
    private static let yaBlackDark = UIColor.white
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")
}
