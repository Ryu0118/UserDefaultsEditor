import SwiftUI
import UserDefaultsEditor

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basic Usage") {
                    NavigationLink("UserDefaultsEditor") {
                        UserDefaultsEditor(
                            userDefaults: .standard,
                            presentationStyle: .push
                        )
                    }
                }
                Section("With Key Filter") {
                    NavigationLink("Custom Keys Only") {
                        UserDefaultsEditor(
                            userDefaults: .standard,
                            keyFilter: { key in 
                                key.contains("Key") || key.hasPrefix("app")
                            },
                            presentationStyle: .push
                        )
                    }
                    NavigationLink("System Keys Only") {
                        UserDefaultsEditor(
                            userDefaults: .standard,
                            keyFilter: { key in 
                                key.hasPrefix("NS") || key.hasPrefix("Apple") || key.hasPrefix("com.apple")
                            },
                            presentationStyle: .push
                        )
                    }
                }
                Section {
                    Button("Add Integer Value") {
                        UserDefaults.standard.set(1, forKey: "integerKey")
                    }
                    Button("Add String Value") {
                        UserDefaults.standard.set("string", forKey: "stringKey")
                    }
                    Button("Add Data Value") {
                        UserDefaults.standard.set("[{ \"string\": \"string\", \"integer\": 1 }]".data(using: .utf8), forKey: "dataKey")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
