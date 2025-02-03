//
//  Constants.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

// Typealias
typealias COMPLETION_HANDLER = (_ status: Alert) -> Void
typealias FORMDATA_PARAMETERS = [String:String]
typealias JSON_PARAMETERS = [String:Any]

// Cells Identifier
let CAR_SELECT_CELL = "addCarCell"
let PROFILE_COLLECTION_CELL = "profileCollecitonCell"
let PROFILE_TABLEVIEW_CELL = "profileTableViewCell"
let CALL_US_CELL = "callUSCell"
let CONTENT_DEFAULT_CELL = "defaultCell"
let NEWS_CELL = "newsCell"
let CAR_SERVICE_COLLECTION_VIEW_CELL = "carServiceCollectionViewCell"
let OTHER_CAR_SERVICE_COLLECTION_VIEW_CELL = "otherCarServiceCollectionViewCell"
let NERKH_KHODRO_CELL = "nerkhKhodroCell"
let MAP_SEARCH_CELL_ID = "mapSearchCellID"
let SERVICE_ORDER_CELL_ID = "serviceOrderCellID"
let EMDAD_KHODRO_CELL = "emdadKhodroCell"
let ORDER_CELL = "orderCell"
let BOOKING_COLLECTION_CELL = "bookingCell"
let NEAR_CELL = "nearCell"

// Storuboard IDs
let RIGHT_SIDE_NAVIGATION_ID = "RightMenuNavigationController"
let ADD_CAR_VIEW_CONTROLLER_ID = "AddCarViewControllerID"
let REGISTRATION_VIEW_CONTROLLER_ID = "RegistrerationViewControllerID"
let CONTENT_VIEW_CONTROLLER_ID = "ContentViewControllerID"
let CONTACT_US_VIEW_CONTROLLR_ID = "ContactUsViewControllerID"
let WEB_VIEW_CONTROLLER_ID = "ContactUsViewControllerID"
let CONTENT_NAVIGATION_CONTROLLER_ID = "contentNavigationControllerID"
let DESCRIPTION_VIEW_CONTROLLER_ID = "LongDescriptionViewControllerID"
let GOOGLE_COORDINATE_VC_ID = "googleCoordinateVCID"
let PISHNEHAD_VC_ID = "pishnehadVCID"
let MAP_SEARCH_CONTROLLER_ID = "mapSearchControllerID"
let CARIO_CONTENT_PAGE_VIEW_CONTROLLER_ID = "carioContentPageViewControllerID"
let CARIO_PAGE_VIEW_VIEW_CONTROLLER_ID = "carioPageViewControllerID"

// Segues
let SIDEBAR_SEGUE = "sideBarSegue"
let REGISTRATION_TO_CONFIRM_SEGUE = "registerationToConfirmSegue"
let LOGIN_TO_CONFIRM_SEGUE = "loginToConfirmSegue"
let CONFIRM_TO_LOADER_SEGUE = "confirmToLoaderVC"
let ADD_CAR_TO_LOADER_SEGUE = "addcarToLoaderSegue"
let LOADER_TO_MAIN_SEGUE = "loaderToMainSegue"
let TO_DEFAULT_VIEW_CONTROLLER_SEGUE = "toDefaultViewControllerSegue"
let TO_DETAIL_CONTENT_SEGUE = "toDetailContentSegue"
let SUGGESTION_VIEW_CONTROLLER_SEGUE = "suggestionViewControllerSegue"
let TO_LOCATION_SELECTED_SEGUE = "locationSelected"
let TO_ORDER_VIEW_CONTROLLER_SEGUE = "toOrderViewController"
let ORDER_VC_TO_MAIN_VC_SEGUE = "unwindOrderVCToMainVC"
let BOOKING_NEAR_TO_DETAIL_LOCATION_SEGUE = "bookingToDetailSegue"
let BOOKING_NEAR_TO_ON_MAP_LOCATION_SEGUE = "bookingToOnMapSegue"
let BOOKING_TO_PLACE_SEARCH_SEGUE = "bookingToPlaceSearchSegue"

// Observers
let DISMISS_INDICATOR_VC_NOTIFY = Notification.Name("dismissedIndicatorViewController")
let UPDATE_PROFILE_NOTIFY = Notification.Name("updateProfileNotify")
let PRESNET_WARNING_ORDER_VC_NOTIFY = Notification.Name("presentWarningOrderVCNotify")
let REMOVE_VERSION_VC = Notification.Name("removeVersionVCNotify")
let SELECTED_OTHER_CAR_SERVICE_ELEMENT = Notification.Name("selectedOtherCarServiceElementNotify")
let SELECTED_CAR_SERVICE_ELEMENT = Notification.Name("selectedCarServiceElementNotify")
let CHECK_COMPLETE_ORDER_SUBMIT = Notification.Name("checkCompleteOrderSubmit")

// Userdefaults Key
let USER_DEFAULT_KEY = "group.iPersianDeveloper.cario"
let IS_LOGGED_IN_KEY = "isLoggedInKey"
let SESSION_KEY = "sessionKey"
let USER_ID_KEY = "userIdKey"
let VERSION_KEY = "versionKey"
let PRESENT_REGISTER_VC_KEY = "presentRegisterVCKey"
let PRESENT_ADD_CAR_KEY = "presentAddCarKey"
let SELECTED_CAR_INDEX_KEY = "selectedStageIndex"
let TIP_KEY = "TIP_KEY"
let MINIMUM_VERSION_APP = "minimumVersionApplication"
let MESSAGE_SINGLE_ID_KEY = "messageSingleIdKey"
let FIRST_TIME_RULES_AND_POLICY = "firstTimeRulesAndPolicy"
let PRESENT_PAGE_VIEW_CONTROLLER_KEY = "presentPageViewControllerKey"

// URLs
let BASE_URL = "http://app.cario.ir/"

// Google API Key
let GOOGLE_API_KEY = "AIzaSyAZ_Ml6iEE3HoBsno-seFt7lZ2Bcd9Bhhk"

// Heards
let JSON_HEAD = ["Content-Type": "application/json; charset=utf-8"]

// Font Name
let IRAN_SANS_MOBILE_FONT = "IRANSansMobile(FaNum)"
let IRAN_SANS_BOLD_MOBILE_FONT = "IRANSansMobileFaNum-Bold"

// Application Version
let VERSION = "8"
