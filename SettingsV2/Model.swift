import UIKit

enum ListItem: Hashable {
    case header(HeadersItem)
    case item(SettingsItem)
}

class HeadersItem: Hashable {
    var identifier: UUID
    var title: String
    var iconName: String
    var items: [SettingsItem]
  
    init(title: String, iconName: String, items: [SettingsItem]) {
        self.identifier = UUID()
        self.title = title
        self.iconName = iconName
        self.items = items
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  static func == (lhs: HeadersItem, rhs: HeadersItem) -> Bool {
    lhs.identifier == rhs.identifier
  }
}

class SettingsItem: Hashable {
    let identifier: UUID
    let title: String
    let subTitle: String?
    let iconName: String
    
    init(title: String, subTitle: String? = nil, iconName: String) {
        self.identifier = UUID()
        self.title = title
        self.subTitle = subTitle
        self.iconName = iconName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


extension HeadersItem {
    static var generatedTestData: [HeadersItem] = [
        HeadersItem(title: "About", iconName: "info.circle.fill", items: [
            SettingsItem(title: "About User", iconName: "person"),
            SettingsItem(title: "About Phone", iconName: "doc.text.magnifyingglass")
        ]),
        HeadersItem(title: "Networking", iconName: "globe", items: [
            SettingsItem(title: "Airplane Mode", subTitle: "Off", iconName: "airplane"),
            SettingsItem(title: "Wifi", subTitle: "Panchal-5G", iconName: "wifi"),
            SettingsItem(title: "Bluetooth", subTitle: "Off", iconName: "minus.circle"),
            SettingsItem(title: "Mobile Data", subTitle: "On", iconName: "antenna.radiowaves.left.and.right"),
            SettingsItem(title: "Hotspot", subTitle: "Off", iconName: "personalhotspot"),
        ]),
        HeadersItem(title: "Notification", iconName: "bell", items: [
            SettingsItem(title: "Speaker", iconName: "speaker.2"),
            SettingsItem(title: "Focus Mode", iconName: "moon"),
            SettingsItem(title: "ScreenTime", iconName: "hourglass.bottomhalf.fill"),
        ]),
        HeadersItem(title: "General", iconName: "gear", items: [
            SettingsItem(title: "Control Centre", iconName: "rectangle.3.offgrid"),
            SettingsItem(title: "Home Screen", iconName: "circle.grid.3x3.fill"),
            SettingsItem(title: "Wallpaper", iconName: "circle.grid.hex"),
            SettingsItem(title: "Battery", iconName: "battery.25"),
        ]),
        HeadersItem(title: "Privacy", iconName: "hand.raised.slash", items: [
            SettingsItem(title: "Touch ID & Passcode", iconName: "lock.circle"),
            SettingsItem(title: "Wallet", iconName: "creditcard"),
            SettingsItem(title: "Location", iconName: "location"),
        ]),
        HeadersItem(title: "Apps", iconName: "square.stack.3d.up", items: [
            SettingsItem(title: "App Setting 1", iconName: "1.circle"),
            SettingsItem(title: "App Setting 2", iconName: "2.circle"),
            SettingsItem(title: "App Setting 3", iconName: "3.circle"),
            SettingsItem(title: "App Setting 4", iconName: "4.circle"),
            SettingsItem(title: "App Setting 5", iconName: "5.circle"),
            SettingsItem(title: "App Setting 6", iconName: "6.circle"),
            SettingsItem(title: "App Setting 7", iconName: "7.circle"),
        ])
    ]
}
