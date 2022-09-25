import Foundation
import ComposableArchitecture

struct RootState: Equatable {
    var loadThenNavigateListState = LoadThenNavigateListState()
}

enum RootAction {
    case onAppear
    case loadThenNavigateList(LoadThenNavigateListAction)
}

struct RootEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    .init { state, action, _ in
      switch action {
      case .onAppear:
        state = .init()
        return .none

      default:
        return .none
      }
    },
    loadThenNavigateListReducer
        .pullback(
            state: \.loadThenNavigateListState,
            action: /RootAction.loadThenNavigateList,
            environment: { .init(mainQueue: $0.mainQueue) }
        )
)
