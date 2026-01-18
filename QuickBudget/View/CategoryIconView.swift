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
    private var categories: [CategoryModel]

    @Environment(\.modelContext)
    private var context
    //@Binding var selectedCategory: CategoryModel?
    @Binding var selectedImage: String
    @Binding var selectedImageName: String
    @Binding var contextMenuOn: Bool

    let onEdit: (CategoryModel) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { item in
                    VStack {
                        Image(systemName: item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(selectedImage == item.icon
                                          ? Color.blue.opacity(0.2)
                                          : Color.gray.opacity(0.1))
                            )
                            .overlay(
                                Circle().stroke(
                                    selectedImage == item.icon
                                    ? Color.blue
                                    : .clear,
                                    lineWidth: 2
                                )
                            )
                            .onTapGesture {
                                selectedImage = item.icon
                                selectedImageName = item.name
                                onEdit(item)
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
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }

                        Text(item.name)
                            .font(.caption)
                    }
                    .frame(height: 100)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
 
    @State var selectedImage = ""
    @State var selectedImageName = ""
    @State var contextMenuOn: Bool = true
    CategoryIconView(selectedImage: $selectedImage, selectedImageName: $selectedImageName, contextMenuOn: $contextMenuOn, onEdit: { _ in })
}

