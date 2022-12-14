import ComposableArchitecture
import Foundation


struct LoadThenNavigateListState: Equatable {
    var rows: IdentifiedArrayOf<Row> = [
        Row(count: 1, id: UUID()),
        Row(count: 42, id: UUID()),
        Row(count: 100, id: UUID()),
    ]
    var selection: Identified<Row.ID, CounterState>?

    struct Row: Equatable, Identifiable {
        var count: Int
        let id: UUID
        var isActivityIndicatorVisible = false
    }
}

enum LoadThenNavigateListAction: Equatable {
    case counter(CounterAction)
    case onDisappear
    case setNavigation(selection: UUID?)
    case setNavigationSelectionDelayCompleted(UUID)
}

struct LoadThenNavigateListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let loadThenNavigateListReducer =
counterReducer
    .pullback(
        state: \Identified.value,
        action: .self,
        environment: { $0 }
    )
    .optional()
    .pullback(
        state: \LoadThenNavigateListState.selection,
        action: /LoadThenNavigateListAction.counter,
        environment: { _ in CounterEnvironment() }
    )
    .combined(
        with: Reducer<
        LoadThenNavigateListState, LoadThenNavigateListAction, LoadThenNavigateListEnvironment
        > { state, action, environment in

            enum CancelId {}

            switch action {
            case .counter:
                return .none

            case .onDisappear:
                return .cancel(id: CancelId.self)

            case let .setNavigation(selection: .some(navigatedId)):
                for row in state.rows {
                    state.rows[id: row.id]?.isActivityIndicatorVisible = row.id == navigatedId
                }

                return Effect(value: .setNavigationSelectionDelayCompleted(navigatedId))
                    .delay(for: 1, scheduler: environment.mainQueue)
                    .eraseToEffect()
                    .cancellable(id: CancelId.self, cancelInFlight: true)

            case .setNavigation(selection: .none):
                if let selection = state.selection {
                    state.rows[id: selection.id]?.count = selection.count
                }
                state.selection = nil
                return .cancel(id: CancelId.self)

            case let .setNavigationSelectionDelayCompleted(id):
                state.rows[id: id]?.isActivityIndicatorVisible = false
                state.selection = Identified(
                    CounterState(count: state.rows[id: id]?.count ?? 0),
                    id: id
                )
                return .none
            }
        }
    )
