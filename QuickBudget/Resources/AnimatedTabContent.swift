import SwiftUI

/*struct AnimatedTabContent<Content: View>: View {
    let index: Int
    let selectedIndex: Int
    let content: Content

    //direction of the animations (left/right)
    @State private var previousIndex: Int = 0
    
    
    //calculated direction of the animation
    //new index is higher -> animation to the right
    //new index is lower -> animation to the left
    var direction: CGFloat {
        selectedIndex > previousIndex ? 1 : -1
    }

    init(index: Int, selectedIndex: Int, @ViewBuilder content: () -> Content) {
        self.index = index
        self.selectedIndex = selectedIndex
        self.content = content()
    }

    var body: some View {
        ZStack {
            // leaving animation of the tab
            if previousIndex == index {
                content
                    .offset(x: selectedIndex == index ? 0 : -direction * UIScreen.main.bounds.width)
                    .animation(.easeInOut(duration: 0.25), value: selectedIndex)
            }

            if selectedIndex == index {
                content
                    .offset(x: previousIndex == index ? direction * UIScreen.main.bounds.width : 0)
                    .animation(.easeInOut(duration: 0.25), value: selectedIndex)
            }
        }
        .onChange(of: selectedIndex) { newValue in
            previousIndex = index
        }
    }
}
*/
