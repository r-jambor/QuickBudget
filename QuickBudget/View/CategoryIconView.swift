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

    @Binding var selectedImage: String
    @Binding var selectedImageName: String
    @Binding var contextMenuOn: Bool

    @ViewBuilder
    private func iconCircle(isSelected: Bool, systemName: String) -> some View {
        let fillColor: Color = isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
        let strokeColor: Color = isSelected ? Color.blue : .clear

        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 55, height: 55)
            .padding(10)
            .background(
                Circle()
                    .fill(fillColor)
            )
            .overlay(
                Circle().stroke(strokeColor, lineWidth: 2)
            )
    }

    /// vrací PersistentIdentifier vybrané kategorie
    let onSelect: (PersistentIdentifier?) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.id) { item in
                    let isSelected = (selectedImage == item.icon)
                    VStack {
                        iconCircle(isSelected: isSelected, systemName: item.icon)
                            .contentShape(Circle())
                            .onTapGesture {
                                selectedImage = item.icon
                                selectedImageName = item.name
                                onSelect(item.id)
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

/*#Preview {
 
    @State var selectedImage = ""
    @State var selectedImageName = ""
    @State var contextMenuOn: Bool = true
    CategoryIconView(selectedImage: $selectedImage, selectedImageName: $selectedImageName, contextMenuOn: $contextMenuOn, onEdit: { _ in })
}
*/

