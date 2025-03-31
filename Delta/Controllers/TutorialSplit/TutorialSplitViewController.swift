//
//  TutorialSplitViewController.swift
//  Project
//
//  Created by Domenico Gonnelli on 12/02/24.
//

import Foundation
import SwiftUI
import CollectionViewPagingLayout
import UIKit
import Lottie



@available(iOS 15.0, *)
class TutorialSplitViewController: UIViewController {

    fileprivate var statusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle ?? .lightContent
    }
    
    static func makeViewController<T: View>(_ view: T,
                                             statusBarStyle: UIStatusBarStyle?) -> TutorialSplitViewController {
        let viewController = TutorialSplitViewController()
        viewController.statusBarStyle = statusBarStyle
        viewController.view.fill(with: UIHostingController(rootView: view).view)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

}

struct TutorialSplit: Identifiable {
    let textColor: SwiftUI.Color
    let title: String
    let text: String
    let icon: String
    let color: SwiftUI.Color
    var animation: String?
    var backgroundImg: String?
    var id: String {
        title
    }

}

@available(iOS 15.0, *)
struct TutorialSplitView: View {

    private let devices: [TutorialSplit] = OnBoardingDataSource.controllersDevices

    private let scaleFactor: CGFloat = 130
    private let circleSize: CGFloat = 80
    private let arrowSize: CGFloat = 30
    
    var controller: UIViewController?

    @State private var currentDeviceName: String?

    var body: some View {
        
        TransformPageView(devices, selection: $currentDeviceName) { device, progress in
            
            ZStack {
                roundedRectangle(device: device, progress: progress)
                deviceView(device: device, progress: progress)
                
                HStack {
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .font(.system(size: arrowSize))
                .transformEffect(.init(translationX: -300 * (progress - 1), y: 0))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 120)
                .opacity(1 - Double(abs(progress - 1)))
            }
        }
        .animator(DefaultViewAnimator(0.7, curve: .parametric))
        .scrollToSelectedPage(false)
        .onTapPage { name in
            if currentDeviceName == devices.last?.title {
                self.controller?.dismiss(animated: true)
            } else {
                currentDeviceName = currentDeviceName == devices.last?.title ? devices.first?.title : name
            }
        }
        .zPosition(zPosition)
        .collectionView(\.showsHorizontalScrollIndicator, false)
        .ignoresSafeArea()
    }
    
    private func attributedText(key: String) -> AttributedString {
        let label = UILabel()
        label.updateFont(fontName: FontStyle.book.rawValue , size: 14)
        label.localizedKey = key
        let attr = label.attributedString
        return AttributedString(attr)
    }
    
    private func deviceView(device: TutorialSplit, progress: CGFloat) -> some View {

        if currentDeviceName == nil {
            currentDeviceName = devices.first?.title
        }
        
       let op: Double = currentDeviceName == device.title ? 1 : 0

       return ZStack{
            Image(device.backgroundImg ?? "")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(op)
            VStack {
                if let anim =  device.animation {
                    LottieView(name: anim, loopMode: .loop)
                        .frame(width: 180, height: 180)
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 200)
                }
                else {
                    Image(device.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.top, 180)
                }
                Text(attributedText(key: device.title))
                    .padding(.horizontal, 20)
                    .padding(.top, 35)
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                    .foregroundColor(device.textColor)
                Text(attributedText(key: device.text))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 12)
                    .frame(alignment: .center)
                    .foregroundColor(device.textColor)
                Spacer()
                    .frame(maxHeight: 200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
            
        }
        .transformEffect(.init(translationX: 400 * progress, y: 0))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }

    private func roundedRectangle(device: TutorialSplit, progress: CGFloat) -> some View {
        let scale = getScale(progress)
        return RoundedRectangle(cornerRadius: circleSize * ((0.2 * scaleFactor) / scale))
            .fill()
            .frame(width: circleSize, height: circleSize)
            .scaleEffect(scale, anchor: scaleAnchor(progress))
            .transformEffect(.init(translationX: translationX(progress), y: 0))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 120 - circleSize/2 + arrowSize/2)
            .foregroundColor(device.color)
            .opacity((1.25 - max(1, abs(Double(progress)))) / 0.25)
    }

    private func translationX(_ progress: CGFloat) -> CGFloat {
        guard progress >= 1 || progress < -0.5 else { return 0 }
        return -2 * (progress + (progress > 0 ? -1 : 1)) * circleSize
    }

    private func zPosition(_ progress: CGFloat) -> Int {
        if progress < -1 { return 3 }
        if progress < 0 { return 2 }
        if progress < 0.5 { return 1 }
        if progress <= 1 { return 4 }
        if progress < 1.5 { return 2 }
        return -1
    }

    private func getScale(_ progress: CGFloat) -> CGFloat {
        var scale: CGFloat = progress > 1 ? progress - 1 : 1 - progress
        if progress <= -1 {
            scale = -progress - 1
        } else if progress < -0.5 {
            scale = progress + 1
        } else if progress <= 0.5 {
            scale = scaleFactor
        }
        return 1 + scale * scaleFactor
    }

    private func scaleAnchor(_ progress: CGFloat) -> UnitPoint {
        if progress <= -1 { return .leading }
        if progress <= -0.5 { return .trailing }
        if progress < 0.5 { return .center }
        if progress < 1 { return .leading }
        return .trailing
    }
}


@available(iOS 15.0, *)
struct TutorialSplitView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialSplitView()
            .ignoresSafeArea()
    }
}

struct LottieView: UIViewRepresentable {
    var name = "success"
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = 0.8
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
