//
//  CategoryIconView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 18.11.2025.
//

import SwiftUI

struct CategoryIconView: View {
    
    
    @EnvironmentObject var cashViewModel: CashFlowViewModel
  //  @Bindable var cashFlow: CashFlowModel
    
    @Binding var selectedImage: String
    @Binding var selectedImageName: String
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var contextMenuOn: Bool
    
    @State private var showEditCategory = false
   // @State private var editingCategory: CategoryModel?
    
    let onEdit: (IconCategoryModel) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(cashViewModel.iconCategoryModel) { item in
                    VStack {
                        Image(systemName: item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(selectedImage == item.icon ? Color.blue.opacity(0.2): Color.gray.opacity(0.1))
                            )
                            .overlay(
                                Circle().stroke(selectedImage == item.icon ? Color.blue : .clear, lineWidth: 2)
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
                                        cashViewModel.delete(item: item)
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
 
    @State var selcetedImage = ""
    @State var selcetedImageName = ""
    @State var contextMenuOn: Bool = true
    CategoryIconView(selectedImage: $selcetedImage, selectedImageName: $selcetedImageName, contextMenuOn: $contextMenuOn, onEdit: IconCategoryModel(icon: "", name: ""))
        .environmentObject(CashFlowViewModel())
}
*/
