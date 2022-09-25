//
//  RootView.swift
//  CaseStudy-Navigation
//
//  Created by ky on 2022/09/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store = Store(
        initialState: RootState(),
        reducer: rootReducer,
        environment: .init(mainQueue: .main)
    )
    var body: some View {
        NavigationView {
            LoadThenNavigateListView(
                store: self.store.scope(
                    state: \.loadThenNavigateListState,
                    action: RootAction.loadThenNavigateList
                )
            )
        }
    }
}
