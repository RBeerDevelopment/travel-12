//
//  ShowToast.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 20.05.25.
//

import Toasts
import SwiftUI

@MainActor
func showFavoriteToast(presentToast: PresentToastAction, isRemove: Bool, isSuccess: Bool) {
    
    let message = isSuccess ?
        "\(isRemove ? "Removed" : "Added") Favorite" :
        "Failed to \(isRemove ? "remove" : "add") favorite"
    let icon = Image(systemName: isRemove ? "star" : "star.fill").tint(isSuccess ? .green : .red)

    let toast = ToastValue(
        icon: icon,
        message: message
    )
    presentToast(toast)
}
