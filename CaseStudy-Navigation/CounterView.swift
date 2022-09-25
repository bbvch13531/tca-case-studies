import ComposableArchitecture
import SwiftUI

struct CounterView: View {
  let store: Store<CounterState, CounterAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Button("−") { viewStore.send(.decrementButtonTapped) }
        Text("\(viewStore.count)")
          .font(.body.monospacedDigit())
        Button("+") { viewStore.send(.incrementButtonTapped) }
      }
    }
  }
}
