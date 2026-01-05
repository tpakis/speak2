import SwiftUI

struct DictionaryEntryRow: View {
    let entry: DictionaryEntry
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 12) {
            // Enable toggle
            Button(action: onToggle) {
                Image(systemName: entry.isEnabled ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(entry.isEnabled ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .help(entry.isEnabled ? "Disable" : "Enable")

            // Category icon
            Image(systemName: entry.category.icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
                .help(entry.category.displayName)

            // Word and aliases
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.word)
                    .fontWeight(.medium)

                if !entry.aliases.isEmpty {
                    Text("Also: \(entry.aliases.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let pronunciation = entry.pronunciation, !pronunciation.isEmpty {
                    Text("[\(pronunciation)]")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

            Spacer()

            // Actions (visible on hover)
            if isHovering {
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(.borderless)
                    .help("Edit")

                    Button(action: onDelete) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                    .help("Delete")
                }
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .opacity(entry.isEnabled ? 1.0 : 0.6)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
