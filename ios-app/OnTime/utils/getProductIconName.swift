//
//  getProductIcon.swift
//  OnTime - Transit
//
//  Created by Robin Beer on 06.04.26.
//

func getProductIconName(_ productType: ProductType) -> String {
    switch productType {
    case .bus:
        return "bus.fill"
    case .ferry:
        return "ferry.fill"
    case .express, .regional:
        return "train.side.rear.car"
    case .suburban:
        return "tram.fill"
    case .subway:
        return "tram.fill.tunnel"
    case .tram:
        return "lightrail.fill"
    }
}
