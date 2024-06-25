import EditValueView
import SwiftUI

/// `UserDefaultsEditor` provides a SwiftUI view for modifying UserDefaults values. It leverages EditValueView for the individual value modification views, offering a user-friendly interface for debugging and editing UserDefaults entries directly within your app. This view supports both push and modal presentation styles.
public struct UserDefaultsEditor: View {
    /// Defines the presentation style of the UserDefaults editor view.
    public enum PresentationStyle {
        case push   // Presents the editor in a push navigation style.
        case modal  // Presents the editor modally.
    }

    @State var presentedValue: UserDefaultsRepresentation?
    @State var allValues: [UserDefaultsRepresentation]
    
    let presentationStyle: PresentationStyle
    let dataSource: () -> [String: Any]
    let write: (_ key: String, _ newValue: Any) -> Void
    let remove: (_ key: String) -> Void

    /// Initializes a `UserDefaultsEditor` view with the specified presentation style and UserDefaults source.
    /// - Parameters:
    ///   - userDefaults: The UserDefaults instance to edit.
    ///   - presentationStyle: The presentation style for the editor (default is `.push`).
    public init(
        userDefaults: UserDefaults,
        presentationStyle: PresentationStyle = .push
    ) {
        self.init(
            presentationStyle: presentationStyle,
            dictionary: userDefaults.dictionaryRepresentation(),
            write: { userDefaults.set($1, forKey: $0) },
            remove: { userDefaults.removeObject(forKey: $0) }
        )
    }

    fileprivate init(
        presentationStyle: PresentationStyle,
        dictionary: @escaping @autoclosure () -> [String: Any],
        write: @escaping (_ key: String, _ newValue: Any) -> Void,
        remove: @escaping (_ key: String) -> Void
    ) {
        let allValues = dictionary().userDefaultsRepresentations()
        self._allValues = .init(initialValue: allValues)
        self.write = write
        self.presentationStyle = presentationStyle
        self.remove = remove
        self.dataSource = dictionary
    }

    public var body: some View {
        switch presentationStyle {
        case .push:
            core
        case .modal:
            NavigationView {
                core
            }
        }
    }

    private var core: some View {
        List {
            ForEach(allValues) { data in
                HStack {
                    Text(data.key)
                    Spacer()
                    Text(String(reflecting: data.type.associatedValue))
                        .foregroundColor(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    presentedValue = data
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { remove(allValues[$0].key) }
                update()
            }
        }
        .refreshable {
            update()
        }
        .onAppear {
            update()
        }
        .sheet(item: $presentedValue) { value in
            switch value.type {
            case .string(let string):
                EditValueView(key: value.key, value: string)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .array(let array):
                EditValueView(key: value.key, value: array)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .dictionary(let dictionary):
                EditValueView(key: value.key, value: dictionary)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .data(let data):
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    EditValueView(key: value.key, value: json)
                        .onUpdate { newValue in
                            guard let data = try? JSONSerialization.data(withJSONObject: newValue) else {
                                return
                            }
                            
                            write(value.key, data)
                        }
                } else {
                    EditValueView(key: value.key, value: data)
                        .onUpdate { newValue in
                            write(value.key, newValue)
                            update()
                        }
                }

            case .stringArray(let array):
                EditValueView(key: value.key, value: array)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .integer(let int):
                EditValueView(key: value.key, value: int)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .float(let float):
                EditValueView(key: value.key, value: float)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .double(let double):
                EditValueView(key: value.key, value: double)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .bool(let bool):
                EditValueView(key: value.key, value: bool)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .url(let url):
                EditValueView(key: value.key, value: url)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .date(let date):
                EditValueView(key: value.key, value: date)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            case .object(let any):
                EditValueView(key: value.key, value: any)
                    .onUpdate { newValue in
                        write(value.key, newValue)
                        update()
                    }
            }
        }
    }

    func update() {
        allValues = dataSource().userDefaultsRepresentations()
    }
}

extension [String: Any] {
    func userDefaultsRepresentations() -> [UserDefaultsRepresentation] {
        self
            .sorted(by: { $0.key < $1.key })
            .reduce(into: [UserDefaultsRepresentation]()) { partialResult, element in
                partialResult.append(
                    UserDefaultsRepresentation(
                        key: element.key,
                        type: UserDefaultsType.identify(element.value)
                    )
                )
            }
    }
}

#Preview {
    UserDefaultsEditor(
        presentationStyle: .modal,
        dictionary: [
            "string": "hoge",
            "array": [1, "2", 3],
            "dictionary": ["a": 0],
            "data": "{ \"string\": \"string\", \"integer\": 1 }".data(using: .utf8)!,
            "stringArray": ["a", "b"],
            "integer": 1,
            "float": Float(1),
            "double": Double(1),
            "bool": false,
            "url": URL(string: "https://google.com")!,
            "date": Date()
        ],
        write: { _, _ in },
        remove: { _ in }
    )
}
