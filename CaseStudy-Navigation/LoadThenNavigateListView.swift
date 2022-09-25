import SwiftUI
import ComposableArchitecture

let readMe = """
THIS is Long Long Text.
THIS is Long Long Text\
THIS is Long Long Text
"""

struct LoadThenNavigateListView: View {
    let store: Store<LoadThenNavigateListState, LoadThenNavigateListAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section(header: Text(readMe)) {
                    ForEach(viewStore.rows) { row in
                        NavigationLink(
                            destination: IfLetStore(
                                store.scope(
                                    state: \.selection?.value,
                                    action: LoadThenNavigateListAction.counter
                                )
                            ) {
                                CounterView(store: $0)
                            },
                            tag: row.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: LoadThenNavigateListAction.setNavigation(selection:)
                            )
                        ) {
                            HStack {
                                Text("Load optional counter that starts from \(row.count)")
                                if row.isActivityIndicatorVisible {
                                    Spacer()
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Load then navigate")
            .onDisappear { viewStore.send(.onDisappear) }
        }
    }
}

struct LoadThenNavigateListView_Previews: PreviewProvider {
    static var previews: some View {
        LoadThenNavigateListView(
            store: Store(
                initialState: LoadThenNavigateListState(),
                reducer: loadThenNavigateListReducer,
                environment: LoadThenNavigateListEnvironment(mainQueue: .main)
            )
        )
    }
}
