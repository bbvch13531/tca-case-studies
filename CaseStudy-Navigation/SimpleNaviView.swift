import SwiftUI

struct SimpleNaviView: View {
    let colors: [Color] = [.mint, .pink, .teal]
    @State private var selection: Color? // Nothing selected by default.

    var body: some View {
        NavigationSplitView {
            List(colors, id: \.self, selection: $selection) { color in
                NavigationLink(color.description, value: color)
            }
        } detail: {
            if let color = selection {
                ColorDetail(color: color)
            } else {
                Text("Pick a color")
            }
        }
    }
}

struct ColorDetail: View {
    var color: Color
    var body: some View {
        color
    }
}
struct SimpleNaviView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleNaviView()
    }
}
