//
//  ObjStoreProduct.swift
//  AgendaZap
//
//  Created by Dipen on 14/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ObjStoreProduct: NSObject
{
    var strID: String = ""
    var strStoreID: String = ""
    var strCategoryID: String = ""
    var strTitle: String = ""
    var strSlug: String = ""
    var strDescription: String = ""
    var strCityID: String = ""
    var strIsNational: String = ""
    var strProductType: String = ""
    var strMoneyPrice: String = ""
    var strPointPrice: String = ""
    var strNeedAddress: String = ""
    var strRejectReason: String = ""
    var strIsActive: String = ""
    var strStatus: String = ""
    var strQualityScore: String = ""
    var strMoneyText: String = ""
    var strImageURL: String = ""
    var strIsTestData: String = ""
    var strCreatedDate: String = ""
    var strUpdatedDate: String = ""
    
    var strIsReviewes: String = ""
    var strAverageRating: String = ""
    var strAverageRating1: String = ""
    var strAverageRating2: String = ""
    var strAverageRating3: String = ""
    var strAverageRating4: String = ""
    var strAverageRating5: String = ""
    var strTotalRating: String = ""
    var strTotalRating1: String = ""
    var strTotalRating2: String = ""
    var strTotalRating3: String = ""
    var strTotalRating4: String = ""
    var strTotalRating5: String = ""
        
    var arrayProductImages = [String]()
    
    var strStoreName: String = ""
    var strPhoneNumber: String = ""
    var strCity: String = ""
    
    var strIsPromo: String = ""
    var strDiscountedPrice: String = ""
    var strGift: String = ""
    
    var arrayReview = [ObjReview]()
    
    func separateParametersForStoreProduct(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strCategoryID = "\(dictionary["category_id"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        strDescription = "\(dictionary["description"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strIsNational = "\(dictionary["is_national"] ?? "")"
        strProductType = "\(dictionary["product_type"] ?? "")"
        
        var strTemp = "\(dictionary["money_price"] ?? "")"
        strTemp = strTemp.replacingOccurrences(of: ".", with: ",")
        
        strMoneyPrice = strTemp
        strPointPrice = "\(dictionary["points_price"] ?? "")"
        strNeedAddress = "\(dictionary["need_address"] ?? "")"
        strRejectReason = "\(dictionary["reject_reason"] ?? "")"
        strIsActive = "\(dictionary["active"] ?? "")"
        strStatus = "\(dictionary["status"] ?? "")"
        strQualityScore = "\(dictionary["quality_score"] ?? "")"
        strMoneyText = "\(dictionary["money_text"] ?? "")"
        strImageURL = "\(dictionary["images"] ?? "")"
        strIsTestData = "\(dictionary["is_testdata"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strUpdatedDate = "\(dictionary["modified_date"] ?? "")"
        
        strIsReviewes = "\(dictionary["is_reviewed"] ?? "")"
        strAverageRating = "\(dictionary["average_rating"] ?? "")"
        strAverageRating1 = "\(dictionary["average_rating_1"] ?? "")"
        strAverageRating2 = "\(dictionary["average_rating_2"] ?? "")"
        strAverageRating3 = "\(dictionary["average_rating_3"] ?? "")"
        strAverageRating4 = "\(dictionary["average_rating_4"] ?? "")"
        strAverageRating5 = "\(dictionary["average_rating_5"] ?? "")"
        strTotalRating = "\(dictionary["total_rating"] ?? "")"
        strTotalRating1 = "\(dictionary["total_rating_1"] ?? "")"
        strTotalRating2 = "\(dictionary["total_rating_2"] ?? "")"
        strTotalRating3 = "\(dictionary["total_rating_3"] ?? "")"
        strTotalRating4 = "\(dictionary["total_rating_4"] ?? "")"
        strTotalRating5 = "\(dictionary["total_rating_5"] ?? "")"
        
        //IMAGES
        if (strImageURL != "")
        {
            let arrayStoreImagesTemp = strImageURL.components(separatedBy: ",")
            arrayProductImages = [String]()
            arrayProductImages.append(contentsOf: arrayStoreImagesTemp)
        }
        
        strStoreName = "\(dictionary["store_name"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strCity = "\(dictionary["city"] ?? "")"
        
        strIsPromo = "\(dictionary["is_promo"] ?? "0")"
        strDiscountedPrice = "\(dictionary["discounted_price"] ?? "")"
        strGift = "\(dictionary["gift"] ?? "")"
        
        
        arrayReview = [ObjReview]()

        let arrayReviewsLocal = dictionary["reviews"] as? NSArray
        if (arrayReviewsLocal != nil)
        {
            for objReviewTemp in arrayReviewsLocal!
            {
                let objReviewDictionary = objReviewTemp as? NSDictionary
                
                let objNewReview : ObjReview = ObjReview()
                objNewReview .separateParametersForReview(dictionary: objReviewDictionary as! Dictionary<String, Any>)
                
                arrayReview .append(objNewReview)
                
            }
        }
    }
}
