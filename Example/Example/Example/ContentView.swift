import SwiftUI
import UserDefaultsEditor

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("UserDefaultsEditor") {
                        UserDefaultsEditor(
                            userDefaults: .standard,
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
