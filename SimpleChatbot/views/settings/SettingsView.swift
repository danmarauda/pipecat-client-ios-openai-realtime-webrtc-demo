import SwiftUI
import PipecatClientIOS

struct SettingsView: View {
    
    @EnvironmentObject private var model: CallContainerModel
    
    @Binding var showingSettings: Bool
    
    @State private var isMicEnabled: Bool = true
    @State private var openaiAPIKey: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Audio Settings")) {
                    List(model.availableMics, id: \.self.id.id) { mic in
                        Button(action: {
                            model.selectMic(mic.id)
                        }) {
                            HStack {
                                Text(mic.name)
                                Spacer()
                                if mic.id == model.selectedMic {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Start options")) {
                    Toggle("Enable Microphone", isOn: $isMicEnabled)
                }
                Section(header: Text("OpenAI API Key")) {
                    SecureField("OpenAI API Key", text: $openaiAPIKey)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        self.saveSettings()
                        self.showingSettings = false
                    }
                }
            }
            .onAppear {
                self.loadSettings()
            }
        }
    }
    
    private func saveSettings() {
        let newSettings = SettingsPreference(
            selectedMic: model.selectedMic?.id,
            enableMic: isMicEnabled,
            openaiAPIKey: openaiAPIKey
        )
        SettingsManager.updateSettings(settings: newSettings)
    }
    
    private func loadSettings() {
        let savedSettings = SettingsManager.getSettings()
        self.isMicEnabled = savedSettings.enableMic
        self.openaiAPIKey = savedSettings.openaiAPIKey
    }
}

#Preview {
    let mockModel = MockCallContainerModel()
    let result = SettingsView(showingSettings: .constant(true)).environmentObject(mockModel as CallContainerModel)
    return result
}
