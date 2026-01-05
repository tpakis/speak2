import SwiftUI

struct QuickAddSheet: View {
    @EnvironmentObject var dictionaryState: DictionaryState
    @Environment(\.dismiss) private var dismiss

    @State private var word: String = ""
    @State private var aliases: String = ""
    @State private var category: EntryCategory = .custom

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Quick Add Word")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }

            // Word input
            VStack(alignment: .leading, spacing: 4) {
                Text("Word")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Enter word...", text: $word)
                    .textFieldStyle(.roundedBorder)
            }

            // Aliases input
            VStack(alignment: .leading, spacing: 4) {
                Text("Aliases (optional)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Comma-separated alternatives", text: $aliases)
                    .textFieldStyle(.roundedBorder)
            }

            // Category picker
            Picker("Category", selection: $category) {
                ForEach(EntryCategory.allCases, id: \.self) { cat in
                    Text(cat.displayName).tag(cat)
                }
            }
            .pickerStyle(.menu)

            // Language indicator
            HStack {
                Text("Language:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(dictionaryState.selectedLanguage.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
            }

            // Buttons
            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])

                Spacer()

                Button("Add") {
                    addWord()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return, modifiers: [])
                .disabled(word.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding()
        .frame(width: 300)
    }

    private func addWord() {
        let aliasArray = aliases
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let entry = DictionaryEntry(
            word: word.trimmingCharacters(in: .whitespaces),
            language: dictionaryState.selectedLanguage,
            aliases: aliasArray,
            category: category
        )

        dictionaryState.add(entry)
        dismiss()
    }
}
