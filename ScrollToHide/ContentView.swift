//
//  ContentView.swift
//  ScrollToHide
//
//  Created by 张亚飞 on 2021/7/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            Button {
                
                showSheet.toggle()
                
            } label: {
                
                Text("Present Sheet")
            }
            .navigationTitle("Half Modal Sheet")
            .halfSheet(showSheet: $showSheet) {
                
                Text("Hello iJustine")
                    .font(.title.bold())
            }

        }
    }
}


extension View {
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping() -> SheetView)-> some View {
        
        //why use background
        //bcz it will automatically user the swiftui frame size only
        return self
            .background(

                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
            )
    }
}


struct HalfSheetHelper<SheetView: View> : UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear;
        
        return controller;
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true) {
                
                DispatchQueue.main.async {
                    
                    
                    self.showSheet.toggle()
                }
            }
        }
    }
}

//custom UIHostingController for halfSheet...
class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        
        if let presentationController = presentationController as? UISheetPresentationController {
            
            presentationController.detents = [
            
                .medium(),
                .large()
            ]
        }
    }
}
