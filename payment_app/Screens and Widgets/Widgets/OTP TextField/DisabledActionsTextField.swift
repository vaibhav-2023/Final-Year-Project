//
//  DisabledActionsTextField.swift
//  payment_app
//
//  Created by MacBook Pro on 31/12/22.
//

import SwiftUI

//Text Field with no options like copy, cut, paste etc.
//Created it using UIKit
struct DisabledActionsTextField: UIViewRepresentable {

    private let placeholder: String
    @Binding private var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self)
    }
}

extension DisabledActionsTextField {

    func makeUIView(context: UIViewRepresentableContext<DisabledActionsTextField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {

    }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
    var parent: DisabledActionsTextField

    init(_ textField: DisabledActionsTextField) {
        self.parent = textField
    }
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        /* disable particular actions
         if (action == #selector(paste(_:)) || action == #selector(copy(_:)) || action == #selector(select(_:)) || action == #selector(cut(_:)) || action == #selector(delete(_:)) || action == #selector(replace(_:withText:))  || action == #selector(select(_:))  || action == #selector(selectAll(_:)) || action == #selector(insertText(_:)) || action == #selector(draw(_:))) && !isActionsEnabled {
         return false
         }
         return super.canPerformAction(action, withSender: sender)
         */
        
        //disable all actions
        //if action == #selector(UIResponderStandardEditActions.paste(_:)) {
        return false
        //}
        //return canPerformAction(action: action, withSender: sender)
    }
}
