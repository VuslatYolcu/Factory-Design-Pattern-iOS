//
//  AnnotationFactory.swift
//  hello-maps
//
//  Created by Vuslat Yolcu on 30.03.2023.
//  Copyright © 2023 Mohammad Azam. All rights reserved.
//

import Foundation
import MapKit

class AnnotaionFactory {
    
    func createBusinessFactory(business: Business) -> BusinessViewModel {
        
        let businessVM = BusinessViewModel(business)
        
        switch business.rating {
        case 4.5...5:
            businessVM.image = UIImage(named: "great")
        case 3...4:
            businessVM.image = UIImage(named: "bad")
        default:
            businessVM.image = UIImage(named: "terrible")
        }
        
        return businessVM
    }
}
