//
//  AsyncImageView.swift
//  CryptoApp
//
//  Created by Tam Nguyen on 08/07/2021.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(
        urlString: String,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(urlString: urlString, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        ZStack {
            if let imageloaded = loader.image {
                image(imageloaded)
                    .foregroundColor(.accent)
            }  else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
    }
    
}

struct AsyncImageView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            AsyncImageView(
                urlString: dev.coin.image,
                placeholder: { ProgressView() },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .previewLayout(.sizeThatFits)
            
            AsyncImageView(
                urlString: "",
                placeholder: { ProgressView() },
                image: {
                    Image(uiImage: $0)
                        .resizable()
                }
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
    
}
