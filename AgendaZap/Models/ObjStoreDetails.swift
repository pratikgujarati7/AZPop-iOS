//
//  ObjStoreDetails.swift
//  AgendaZap
//
//  Created by Dipen on 21/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjStoreDetails: NSObject
{
    var strID: String = ""
    var strHideAddress: String = ""
    var strName: String = ""
    var strPhoneNumber: String = ""
    var strCountryCode: String = ""
    var strEmail: String = ""
    var strAddress: String = ""
    var strSlug: String = ""
    var strFacebookLink: String = ""
    var strInstagramLink: String = ""
    var strCityID: String = ""
    var strCityName: String = ""
    var strStateID: String = ""
    var strStateName: String = ""
    var strType: String = ""
    var strDescription: String = ""
    var strIsFavourite: String = ""
    var strLatitude: String = ""
    var strLongitude: String = ""
    var strTags: String = ""
    var strStoreTags: String = ""
    var strStoreTime: String = ""
    var strStoreImages: String = ""
    var strPrmotion: String = ""
    var strIsEditUnderApproval: String = ""
    var strIsPromotionUnderApproval: String = ""
    var strIsOwned: String = ""
    var strTaxIdStatus: String = ""
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
    var strFormatedAddress: String = ""
        
    var arrayStoreImages = [String]()
    var arrayTags = [String]()
    var arrayStoreTags = [String]()
    var arrayStoreTimings = [String]()
    
    var arrayReview = [ObjReview]()
    
    func separateParametersForStoreDetails(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strHideAddress = "\(dictionary["hide_address"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strCountryCode = "\(dictionary["country_code"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        if ("\(dictionary["facebook_link"] ?? "")" != "<null>")
        {
            strFacebookLink = "\(dictionary["facebook_link"] ?? "")"
        }
        else
        {
            strFacebookLink = ""
        }
        if ("\(dictionary["instagram_link"] ?? "")" != "<null>")
        {
            strInstagramLink = "\(dictionary["instagram_link"] ?? "")"
        }
        else
        {
            strInstagramLink = ""
        }
        
        strCityID = "\(dictionary["city_id"] ?? "")"
        strCityName = "\(dictionary["city_name"] ?? "")"
        strStateID = "\(dictionary["state_id"] ?? "")"
        strStateName = "\(dictionary["state_name"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        
        if ("\(dictionary["description"] ?? "")" != "<null>")
        {
            strDescription = "\(dictionary["description"] ?? "")"
        }
        
        strIsFavourite = "\(dictionary["is_fav"] ?? "")"
        strLatitude = "\(dictionary["lat"] ?? "")"
        strLongitude = "\(dictionary["lng"] ?? "")"
        
        if ("\(dictionary["tags"] ?? "")" != "<null>")
        {
            strTags = "\(dictionary["tags"] ?? "")"
        }
        if ("\(dictionary["store_tags"] ?? "")" != "<null>")
        {
            strStoreTags = "\(dictionary["store_tags"] ?? "")"
        }
        if ("\(dictionary["store_time"] ?? "")" != "<null>")
        {
            strStoreTime = "\(dictionary["store_time"] ?? "")"
        }
        if ("\(dictionary["store_images"] ?? "")" != "<null>")
        {
            strStoreImages = "\(dictionary["store_images"] ?? "")"
        }
        if ("\(dictionary["promo"] ?? "")" != "<null>")
        {
            strPrmotion = "\(dictionary["promo"] ?? "")"
            strPrmotion = strPrmotion.replacingOccurrences(of: "~", with: "")
        }
        strIsEditUnderApproval = "\(dictionary["is_edit_under_approval"] ?? "")"
        strIsPromotionUnderApproval = "\(dictionary["is_promotion_under_approval"] ?? "")"
        strIsOwned = "\(dictionary["is_owned"] ?? "")"
        strTaxIdStatus = "\(dictionary["tax_id_status"] ?? "")"
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
        strFormatedAddress = "\(dictionary["formatted_address"] ?? "")"
        
        //IMAGES
        if (strStoreImages != "")
        {
            let arrayStoreImagesTemp = strStoreImages.components(separatedBy: ",")
            arrayStoreImages = [String]()
            for strSiderImage in arrayStoreImagesTemp
            {
                arrayStoreImages.append(strSiderImage)
            }
        }
        
        
        //TAGS
        if (strTags != "")
        {
            let arrayTagsTemp = strTags.components(separatedBy: ",")
            arrayTags = [String]()
            for strTag in arrayTagsTemp
            {
                arrayTags.append(strTag)
            }
        }
        
        
        //STORE TAGS
        if (strStoreTags != "")
        {
            let arrayStoreTagsTemp = strStoreTags.components(separatedBy: ",")
            arrayStoreTags = [String]()
            for strStoreTag in arrayStoreTagsTemp
            {
                arrayStoreTags.append(strStoreTag)
            }
        }
        
        
        //TIMINGS
        if (strStoreTime != "")
        {
            let arrayStoreTimingsTemp = strStoreTime.components(separatedBy: ",")
            arrayStoreTimings = [String]()
            for strTiming in arrayStoreTimingsTemp
            {
                let arrayTimingTemp = strTiming.components(separatedBy: "#")
                
                if (arrayTimingTemp.count == 3)
                {
                    let strFinalTime: String = "\(objCommonUtility.arrayWeakDays[Int(arrayTimingTemp[0]) ?? 0]) das \(arrayTimingTemp[1]) até \(arrayTimingTemp[2])"
                    
                    arrayStoreTimings.append(strFinalTime)
                }
                else
                {
                    arrayStoreTimings.append(strTiming)
                }
            }
        }
        
        
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
