//
//  NavSearchSheet.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import SwiftUI

struct NavSearchSheet: View {
    
    @State var startInput: String = ""
    @State var start: String = ""
    @State var destinationInput: String = ""
    @State var destination: String = ""
    
    @State var addressSearchViewModel = AddressSearchViewModel(completer: .init())
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .trailing) {
                VStack(spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "location")
                        TextField("Start", text: $startInput)
                            .autocorrectionDisabled()
                    }
                    Divider().padding(.trailing, 32)
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                        TextField("Destination", text: $destinationInput)
                            .autocorrectionDisabled()
                    }
                }.padding()
                Button {
                    let temp = startInput
                    startInput = destinationInput
                    destinationInput = temp
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.largeTitle)
                }
                .padding(.trailing, 4)
                
            }

            if(addressSearchViewModel.completions.count > 0) {
                List {
                    ForEach(addressSearchViewModel.completions) { completion in
                        Button(action: {
                            print(completion)
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(completion.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                Text(completion.subTitle)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding()
        .onChange(of: startInput) {
            addressSearchViewModel.update(queryFragment: startInput)
        }
        .onChange(of: destinationInput) {
            addressSearchViewModel.update(queryFragment: destinationInput)
        }
    }
}

#Preview {
    NavSearchSheet()
}
