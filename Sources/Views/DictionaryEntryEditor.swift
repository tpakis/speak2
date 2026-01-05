import SwiftUI

struct DictionaryEntryEditor: View {
    let entry: DictionaryEntry?
    let defaultLanguage: SupportedLanguage
    let onSave: (DictionaryEntry) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var word: String = ""
    @State private var pronunciation: String = ""
    @State private var aliases: String = ""
    @State private var category: EntryCategory = .custom
    @State private var selectedLanguage: SupportedLanguage = .english

    private var isEditing: Bool { entry != nil }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(isEditing ? "Edit Entry" : "Add Entry")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()

            Divider()

            // Form
            Form {
                Section {
                    TextField("Word", text: $word)
                        .textFieldStyle(.roundedBorder)

                    TextField("Pronunciation (optional)", text: $pronunciation)
                        .textFieldStyle(.roundedBorder)

                    TextField("Aliases (comma-separated)", text: $aliases)
                        .textFieldStyle(.roundedBorder)
                }

                Section {
                    Picker("Category", selection: $category) {
                        ForEach(EntryCategory.allCases, id: \.self) { cat in
                            Label(cat.displayName, systemImage: cat.icon).tag(cat)
                        }
                    }

                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(SupportedLanguage.allCases, id: \.self) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .padding()

            Divider()

            // Footer
            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])

                Spacer()

                Button(isEditing ? "Save" : "Add") {
                    saveEntry()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return, modifiers: [])
                .disabled(word.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .frame(width: 400, height: 380)
        .onAppear {
            if let entry = entry {
                word = entry.word
                pronunciation = entry.pronunciation ?? ""
                aliases = entry.aliases.joined(separator: ", ")
                category = entry.category
                selectedLanguage = entry.language
            } else {
                selectedLanguage = defaultLanguage
            }
        }
    }

    private func saveEntry() {
        let aliasArray = aliases
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let newEntry: DictionaryEntry

        if let existing = entry {
            newEntry = DictionaryEntry(
                id: existing.id,
                word: word.trimmingCharacters(in: .whitespaces),
                pronunciation: pronunciation.isEmpty ? nil : pronunciation,
                language: selectedLanguage,
                aliases: aliasArray,
                category: category,
                isEnabled: existing.isEnabled,
                createdAt: existing.createdAt,
                updatedAt: Date()
            )
        } else {
            newEntry = DictionaryEntry(
                word: word.trimmingCharacters(in: .whitespaces),
                pronunciation: pronunciation.isEmpty ? nil : pronunciation,
                language: selectedLanguage,
                aliases: aliasArray,
                category: category
            )
        }

        onSave(newEntry)
        dismiss()
    }
}
