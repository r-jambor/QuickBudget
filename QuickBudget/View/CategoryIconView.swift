//
//  CategoryIconView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 18.11.2025.
//

import SwiftUI
import SwiftData

struct CategoryIconView: View {

    @Query(sort: \CategoryModel.name)
    private var categories: [CategoryModel]  // SwiftData

    @Binding var selectedCategoryID: PersistentIdentifier?

    @Binding var selectedImage: String
    @Binding var selectedImageName: String
    @Binding var contextMenuOn: Bool

    @Environment(\.modelContext) private var context

    /// Callback pro edit kategorii
    let onEdit: (CategoryModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { item in
                    let isSelected = selectedImage == item.icon && selectedImageName == item.name

                    VStack {
                        Image(systemName: item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(isSelected
                                          ? Color.blue.opacity(0.25)
                                          : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? Color.blue : .clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedImage = item.icon
                                selectedImageName = item.name
                            }
                            .contextMenu {
                                if contextMenuOn {
                                    Button {
                                        onEdit(item)
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        context.delete(item)
                                        try? context.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }

                        Text(item.name)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

/*#Preview {
 
    @State var selectedImage = ""
    @State var selectedImageName = ""
    @State var contextMenuOn: Bool = true
    CategoryIconView(selectedCategoryID: <#Binding<CategoryModel.ID?>#>, selectedImage: $selectedImage, selectedImageName: $selectedImageName, contextMenuOn: $contextMenuOn, onEdit: { _ in })
}
*/


