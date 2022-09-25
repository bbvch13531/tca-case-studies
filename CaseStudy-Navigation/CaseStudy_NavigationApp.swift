import SwiftUI
import ComposableArchitecture

@main
struct CaseStudy_NavigationApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoadThenNavigateListView(
                    store: Store(
                        initialState: LoadThenNavigateListState(),
                        reducer: loadThenNavigateListReducer,
                        environment: .init(mainQueue: .main)
                    )
                )
            }
//            SimpleNaviView()
        }
    }
}
