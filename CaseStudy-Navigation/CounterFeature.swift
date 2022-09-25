import ComposableArchitecture

struct CounterState: Equatable {
    var count = 0
}

enum CounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
}

struct CounterEnvironment { }

let counterReducer = Reducer<
    CounterState,
    CounterAction,
    CounterEnvironment
> { state, action, _ in
    switch action {
    case .decrementButtonTapped:
        state.count -= 1
        return .none

    case.incrementButtonTapped:
        state.count += 1
        return .none
    }
}
