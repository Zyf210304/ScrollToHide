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
                
                ZStack {
                    
                    Color.red
                    
                    VStack {
                        
                        Text("Hello iJustine")
                            .font(.title.bold())
                        
                        Button {
                            
                            showSheet.toggle()
                            
                        } label: {
                            
                            Text("Close")
                        }
                    }
                   

                }
                .ignoresSafeArea()
            } onEnd: {
                
                print("Dismissed")
            }

        }
    }
}


extension View {
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping() -> SheetView, onEnd: @escaping ()->())-> some View {
        
        //why use background
        //bcz it will automatically user the swiftui frame size only
        return self
            .background(

                HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet, onEnd: onEnd)
            )
    }
}


struct HalfSheetHelper<SheetView: View> : UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        
        return Coordinator(parent: self)
    }
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear;
        
        return controller;
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
            
        }
        else {
            
            uiViewController.dismiss(animated: true)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            
            self.parent = parent
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            
            parent.showSheet = false
            parent.onEnd()
            
            return true
        }
        
//        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//
//           
//        }


    }
    
    
    
}

//custom UIHostingController for halfSheet...
class CustomHostingController<Content: View>: UIHostingController<Content> {
    
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            
            presentationController.detents = [
            
                .medium(),
                .large()
            ]
            
            // to show grab protion... 上面的横条
            presentationController.prefersGrabberVisible = true
        }
    }
}
