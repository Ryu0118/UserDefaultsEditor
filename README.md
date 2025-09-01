# UserDefaultsEditor
A SwiftUI View for Easily Modifying UserDefaults Values for Debugging.

| UserDefaultsEditor | Edit Date | Edit Array |
| ---- | ---- | ---- |
| <img src="https://github.com/Ryu0118/UserDefaultsEditor/assets/87907656/50d7fa56-016a-4bf8-b3f6-6fcfa195f39d" width="200"> | <img src="https://github.com/Ryu0118/UserDefaultsEditor/assets/87907656/8a9bf629-d64c-43bf-8b28-4d0c6f26a72b" width="200"> | <img src="https://github.com/Ryu0118/UserDefaultsEditor/assets/87907656/a27cf31d-7b0e-4275-93cf-ddd7e8441eae" width="200"> |

UserDefaultsEditor uses the [EditValueView](https://github.com/p-x9/EditValueView) for its value modification views. For more information about EditValueView, please visit their GitHub repository.

# Usage
For displaying the view with a push transition, please set presentationStyle to .push. For modal presentation, select .modal.

```Swift
UserDefaultsEditor(
    userDefaults: .standard,
    presentationStyle: .push // or .modal
)
```

## Key Filtering
You can filter which keys are displayed using the `keyFilter` parameter. This is useful for debugging specific parts of your app or hiding sensitive data.

```Swift
// Only show keys that start with "app"
UserDefaultsEditor(
    userDefaults: .standard,
    keyFilter: { key in key.hasPrefix("app") },
    presentationStyle: .push
)

// Hide system keys and only show custom keys
UserDefaultsEditor(
    userDefaults: .standard,
    keyFilter: { key in 
        !key.hasPrefix("NS") && 
        !key.hasPrefix("Apple") && 
        !key.hasPrefix("com.apple")
    },
    presentationStyle: .modal
)
```
