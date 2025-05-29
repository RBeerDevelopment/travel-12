//
//  NavSearchSheet.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 01.05.25.
//

import SwiftUI


struct NavSearchSheet: View {
    
    @State var startInput: String = ""
    @State var start: SearchCompletion? = nil
    @State var destinationInput: String = ""
    @State var destination: SearchCompletion? = nil
    
    @FocusState var isStartInputFocused: Bool
    @FocusState var isDestinationInputFocused: Bool
    
    @State var addressSearchViewModel = AddressSearchViewModel(completer: .init())
    
    @State var isButtonRotated: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .trailing) {
                VStack(spacing: 14) {
                    HStack(spacing: 12) {
                        Image(systemName: "location")
                        TextField("Start", text: $startInput)
                            .autocorrectionDisabled()
                            .focused($isStartInputFocused)
                    }
                    Divider().padding(.trailing, 32)
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                        TextField("Destination", text: $destinationInput)
                            .autocorrectionDisabled()
                            .focused($isDestinationInputFocused)
                    }
                }.padding()
                Button {
                    let tempInput = startInput
                    startInput = destinationInput
                    destinationInput = tempInput
                    
                    let tempLocation = start
                    start = destination
                    destination = tempLocation
                    
                    withAnimation {
                        isButtonRotated.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.largeTitle)
                        .rotationEffect(.degrees(isButtonRotated ? 180 : 0))
                }
                .padding(.trailing, 4)
                
            }
            HStack {
                Spacer()
                Button("Find Route") {
                    addressSearchViewModel.clear()
                    print("Start", start)
                    print("Destination", destination)
                }.frame(minHeight: 20)
                Spacer()
            }

            if(addressSearchViewModel.completions.count > 0) {
                List {
                    ForEach(addressSearchViewModel.completions) { completion in
                        Button(action: {
                            if(isStartInputFocused) {
                                start = completion
                                startInput = completion.title
                                isStartInputFocused = false
                            }
                            if(isDestinationInputFocused) {
                                destination = completion
                                destinationInput = completion.title
                                isDestinationInputFocused = false
                            }
                            addressSearchViewModel.clear()
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
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding()
        .onChange(of: startInput) {
            if(startInput == start?.title) { return }
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
