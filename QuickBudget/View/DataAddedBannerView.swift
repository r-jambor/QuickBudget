//
//  DataAddedBannerView.swift
//  QuickBudget
//
//  Created by Richard Jambor on 12/10/25.
//
import AudioToolbox

import SwiftUI

struct DataAddedBannerView: View {
    
    var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
                    if isVisible {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text(text)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .frame(width: 120,height: 30)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .padding(.horizontal, 40)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 5) // Odsazení – aby to vypadalo, že vyjíždí z Dynamic Islandu
                    }
                    
                    Spacer()
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)
                .onChange(of: isVisible) { newValue in
                            if newValue {
                                // Vibrace (haptika)
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                
                                // Zvuk
                                AudioServicesPlaySystemSound(1519) // "Tink" zvuk
                            }
                        }
            }
    }


#Preview {
    @State var isVisible: Bool = true
    DataAddedBannerView(text: "Saved", isVisible: $isVisible)
}
