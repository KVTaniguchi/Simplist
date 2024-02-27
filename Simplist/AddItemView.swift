//
//  AddItemView.swift
//  Simplist
//
//  Created by Kevin Taniguchi on 2/19/24.
//

import SwiftUI

struct AddItemView: View {
    @State private var name = ""
    @FocusState private var isTextFieldFocused: Bool
    let checkList: Checklist?
    @Binding var isShowingAddItemView: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") {
                    isShowingAddItemView = false
                }
                Spacer()
                Button("Save") {
                    let newItem = Item()
                    if let checklist = self.checkList {
                        newItem.checklist = checklist
                    }
                    newItem.name = self.name
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isShowingAddItemView = false
                    }
                }
            }
            Text("New item").padding()
            TextField("Name", text: $name)
                .focused($isTextFieldFocused)
            Spacer()
        }
        .padding([.horizontal, .top])
        .onAppear {
            DispatchQueue.main.async {
                isTextFieldFocused = true
            }
        }
    }
}
