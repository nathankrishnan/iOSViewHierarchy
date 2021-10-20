import Foundation
import XCTest
import AEXML
/*
 Extension to allow an XCUIElement to use its private API query getter to check if it has children
 Source: https://bit.ly/3aRpMBx
*/
//extension XCUIElement {
//    @nonobjc var query: XCUIElementQuery? {
//        final class QueryGetterHelper { // Used to allow compilation of the `responds(to:)` below
//            @objc var query: XCUIElementQuery?
//        }
//
//        if !self.responds(to: #selector(getter: QueryGetterHelper.query)) {
//            XCTFail("Internal interface changed: tests needs updating")
//            return nil
//        }
//        return self.value(forKey: "query") as? XCUIElementQuery
//    }
//
//    @nonobjc var count: Int {
//        return self.query?.count ?? 0
//    }
//}

struct Utils {
    static func getElementTypeName(_ element: XCUIElement) -> String {
        let baseName = "XCUIElementType"

        switch element.elementType {
        case .activityIndicator:
            return "\(baseName)TypeActivityIndicator"
        case .alert:
            return "\(baseName)TypeAlert"
        case .application:
            return "\(baseName)Application"
        case .browser:
            return "\(baseName)Browser"
        case .button:
            return "\(baseName)Button"
        case .cell:
            return "\(baseName)Cell"
        case .checkBox:
            return "\(baseName)CheckBox"
        case .collectionView:
            return "\(baseName)CollectionView"
        case .comboBox:
            return "\(baseName)ComboBox"
        case .datePicker:
            return "\(baseName)DatePicker"
        case .dialog:
            return "\(baseName)Dialog"
        case .image:
            return "\(baseName)Image"
        case .key:
            return "\(baseName)Key"
        case .keyboard:
            return "\(baseName)Keyboard"
        case .layoutArea:
            return "\(baseName)LayoutArea"
        case .layoutItem:
            return "\(baseName)LayoutItem"
        case .levelIndicator:
            return "\(baseName)LevelIndicator"
        case .link:
            return "\(baseName)Link"
        case .map:
            return "\(baseName)Map"
        case .other:
            return "\(baseName)Other"
        case .popover:
            return "\(baseName)Popover"
        case .radioButton:
            return "\(baseName)RadioButton"
        case .radioGroup:
            return "\(baseName)RadioGroup"
        case .scrollBar:
            return "\(baseName)ScrollBar"
        case .scrollView:
            return "\(baseName)ScrollView"
        case .searchField:
            return "\(baseName)SearchField"
        case .secureTextField:
            return "\(baseName)SecureTextField"
        case .segmentedControl:
            return "\(baseName)SegmentedControl"
        case .slider:
            return "\(baseName)Slider"
        case .staticText:
            return "\(baseName)StaticText"
        case .switch:
            return "\(baseName)Switch"
        case .table:
            return "\(baseName)Table"
        case .tableColumn:
            return "\(baseName)TableColumn"
        case .tableRow:
            return "\(baseName)TableRow"
        case .textField:
            return "\(baseName)TextField"
        case .textView:
            return "\(baseName)TextView"
        case .toggle:
            return "\(baseName)Toggle"
        case .valueIndicator:
            return "\(baseName)ValueIndicator"
        case .webView:
            return "\(baseName)WebView"
        case .window:
            return "\(baseName)Window"
        default:
            return "\(baseName)Any"
        }
    }
    
    static func getElementAttributes(_ element: XCUIElement) -> [String: String] {
        return [
            "type": getElementTypeName(element),
            "title": element.title,
            "identifier": element.identifier,
            "label": element.label,
            "placeholderValue": element.placeholderValue ?? "",
            "isHittable": String(element.isHittable),
            "isEnabled": String(element.isEnabled),
            "isSelected": String(element.isSelected),
            "x": String(Int(element.frame.origin.x)),
            "y": String(Int(element.frame.origin.y)),
            "width": String(Int(element.frame.width)),
            "height": String(Int(element.frame.height))
        ]
    }
    
    static func getViewHierarchy(app: XCUIApplication) -> String {
        let viewHierarchy = AEXMLDocument()
        let body = viewHierarchy.addChild(name: getElementTypeName(app), attributes: getElementAttributes(app))
        
        func traverseElementTree(elementQuery: XCUIElementQuery, body: AEXMLElement) {
            for i in 0..<elementQuery.count {
                let element = elementQuery.element(boundBy: i)
                // Area for potential optimization
                // Check if the element has any children
                if element.children(matching: .any).count > 0 {
                    let child = body.addChild(name: getElementTypeName(element), attributes: getElementAttributes(element))
                    traverseElementTree(elementQuery: element.children(matching: .any), body: child)
                } else {
                    body.addChild(name: getElementTypeName(element), attributes: getElementAttributes(element))
                }
            }
        }
        
        let start = app.children(matching: .any)
        traverseElementTree(elementQuery: start, body: body)
        return viewHierarchy.xml
    }
    
}
