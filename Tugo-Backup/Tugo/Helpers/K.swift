//
//  K.swift
//  Tugo
//
//  Created by Alex on 16/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation



struct K {
    //General constants
    static let googleUserContent = "96697666414-uahgojrt58q1mql7s9k6drsvouln5e07.apps.googleusercontent.com"
    static let sendbirdAPI = "59813740-72F8-49B7-BADA-A481A3EFC049"
    static let stripePublishableKey = "pk_test_NkTmrIX79f2DM4LYqoJNbiBK"
    static let geocodeKey = "AIzaSyB28dKTC74azS2SniLEuG_6jyYkCTC6hpc"
    static let termsSite = "https://www.google.com/"
    
    // MARK:- Cell Identifiers(CollectionView, TableView)
    struct cells {
        
        struct table {
            static let feedTableCell = "FeedTableCell"
            static let depositTableCell = "DepositTableCell"
            static let commentsTableCell = "CommentsTableCell"
            static let plansTableCell = "PlansTableCell"
            static let methodTableCell = "MethodTableCell"
            static let chatCell = "ChatCell"
            static let messageChatTableCell = "MessageChatTableCell"
            static let boxExperiencesTableCell = "BoxExperiencesTableCell"
            static let dateTableCell = "DateTableCell"
            static let searchTableCell = "SearchTableCell"
        
            
            
            struct Host {
                static let imboxHostTableCell = "ImboxHostTableCell"
                static let incomeDetailTableCell = "IncomeDetailTableCell"
                static let incomeHeaderTableCell = "IncomeHeaderTableCell"
                static let incomeFooterTableCell = "IncomeFooterTableCell"
                static let experienceIncomeTableCell = "ExperienceIncomeTableCell"
                static let myTripsTableCell =  "MyTripsTableCell"
                static let addScheduleTableCell = "AddScheduleTableCell"
                static let editScheduleTableCell = "EditScheduleTableCell"
                
            }
            
            struct Complementaries {
                static let tripDetailDateTableCell = "TripDetailDateTableCell"
                
            }
            
        }
        
        struct collection {
            static let storiesCollectionCell = "StoriesCollectionCell"
            static let favouritesCollectionCell = "FavouritesCollectionCell"
            static let favouritesHostCollectionCell = "FavouritesHostCollectionCell"
            static let selectePhotosCollectionCell = "SelectePhotosCollectionCell"
            static let titleHeaderView = "TitleHeaderView"
            static let hourCollectionCell = "HourCollectionCell"
            
            struct Host {
                static let photosEditCollectionCell = "PhotosEditCollectionCell"
            }
        }
        
        
        
        struct complementaries {
            static let selectPhotoCollectionCell = "SelectPhotoCollectionCell"
            static let tripDetailDateTableCell = "TripDetailDateTableCell"
            static let startHourCollectionCell = "StartHourCollectionCell"
        }
        
    }
    
    // MARK:- Segues
    struct segues {
        struct AuthStoryboard {
            static let signInToSignUpCOntroller = "SignInToSignUpCOntroller"
            static let signInControllerToMenu = "SignInControllerToMenu"
            static let signInToUserNameController = "SignInToUserNameController"
            static let signUpToMenu = "SignUpToMenu"
            static let completeToMenu = "completeToMenu"
            static let authToMenuHost = "AuthToMenuHost"
        }
        
        struct FeedStoryBoard {
            static let feedControllerToSearchController = "FeedControllerToSearchController"
            static let feedControllerToDetailsController = "FeedControllerToDetailsController"
            static let feedControllerToDetailsControllerBigger = "FeedControllerToDetailsControllerBigger"
            static let storiesdetailToDetailControllerBigger = "StoriesdetailToDetailControllerBigger"
            static let storiesToCategoryPerStorie = "StoriesToCategoryPerStorie"
            static let storiesdetailToDetailController = "StoriesdetailToDetailController"
            static let feedControllerToProfileController = "FeedControllerToProfileController"
            static let detailToFirsStepController = "DetailToFirsStepController"
            static let firstStepToSecondStep = "FirstStepToSecondStep"
            static let countriesToFeedForCountry = "CountriesToFeedForCountry"
            static let searchToDetailContrioller = "SearchToDetailContrioller"
            static let searchToDetailContriollerBigger = "SearchToDetailContriollerBigger"
            static let detailToChatController = "DetailToChatController"
            static let secondStepToAddPayment = "SecondStepToAddPayment"
            
        }
        
        struct Plans {
            static let plansToDetail = "PlansToDetail"
        }
        
        struct ChatStoryboard {
            static let chatControllerToChatDetail = "ChatControllerToChatDetail"
            static let chatToImageChatDetail = "ChatToImageChatDetail"
        }
        
        struct ProfileStoryBoard {
            static let profileControllerToAuthHost = "ProfileControllerToAuthHost"
            static let profileToBasicInformation = "ProfileToBasicInformation"
            static let profileToPaymentMethods = "ProfileToPaymentMethods"
            static let profileToFavourites = "ProfileToFavourites"
            static let profileToSignIn = "ProfileToSignIn"
            static let profileToChangepassword = "ProfileToChangepassword"
            static let profileToSignInController = "ProfileToSignInController"
            static let profileToCodePendient = "ProfileToCodePendient"
            static let profileToPaymentsHost = "ProfileToPaymentsHost"
            static let preferenceToAddBankAccount = "PreferenceToAddBankAccount"
        }
        
        struct AuthHost {
            static let hostFirstStepToValidateMail = "HostFirstStepToValidateMail"
            static let validateCodeToHostInformation = "ValidateCodeToHostInformation"
            static let lastStepToMenuHost = "LastStepToMenuHost"
            static let validateCodeToMain = "ValidateCodeToMain"
        }
        
        struct MenuHost {
            static let menuToNewExperienceHost = "MenuToNewExperienceHost"
            static let menuToTripHost = "MenuToTripHost"
            static let menuHostToCalendar = "MenuHostToCalendar"
        }
        
        struct Earninngs {
            static let incomeToExperienceIncomeDetail = "IncomeToExperienceIncomeDetail"
        }
        
        struct Trips {
            static let myTripsToEdit = "MyTripsToEdit"
            static let editExperienceToSearchPlaces = "EditExperienceToSearchPlaces"
            static let tripToMainHost = "TripToMainHost"
        }
        
        
        struct ExperiencesHost {
            static let setnewExperienceToSelecteLocation = "SetnewExperienceTOSelecteLocation"
            static let sliderToStartSExperience = "SliderToStartSExperience"
            static let startInfoToSetSchedules = "StartInfoToSetSchedules"
            static let experienceSchedulesToCategories = "ExperienceSchedulesToCategories"
            static let categoriesToSetPrice = "CategoriesoToSetPrice"
            static let setPriceToMyTrips = "SetPriceToMyTrips"
        }
    }
    
    // MARK:- Preferences,DefaultKeys
    struct defaultKeys {
        //Oauth defaultkeys
        struct Auth {
            static let signIn = "signInset"
            static let accessToken = "setAccessToken"
            static let refreshToken = "setrRefreshToken"
            static let expiresIn = "setExpiresIn"
            static let scope = "setScope"
            
            struct Host {
                static let signInhost = "signInhost"
                static let accessToken = "setAccessTokenHost"
                static let refreshToken = "setrRefreshTokenHost"
                static let scope = "setScopeHost"
                static let pendingState = "PendingCode"
                static let incompleteState = "incompleteState"
            }
        }
        
        struct User {
            static let userName = "userName"
            static let userPhoto = "userPhoto"
            static let userID = "userID"
        }
        
        struct profile {
            static let savedStringArray = "SavedStringArray"
        }
        
        
        
        struct others {
            static let setTime = "setTime"
            static let setDate = "setDate"
            static let isSocial = "isSocial"
            static let isNew = "isNew"
            static let aboutMe = "aboutMe"
        }
        
    }
    
    // MARK:- Colors
    struct colors {
        static let floatbuttonOrange = "#E9614D"
        static let orange = "#E9664B"
        static let searchBarBackground = "#F9F9F9"
        static let purple = "#752FEC"
        static let darkPurple = "#460A8F"
    }
    
    // MARK:- Titles, subtitles, rawtext
    struct titles {
        static let textConfirmAlert = "Entendido"
        static let leaveMessage = "Deja un mensaje"
        static let waze = "Waze"
        static let googleMaps = "Google Maps"
        static let mapTitleActionSheet = "Ver en el mapa."
        static let mapMessageActionSheet = "Opciones:"
        static let addCardTitle = "Agregar pago"
        
        struct ProfileActionSheet {
            static let firstItem = "Editar información básica"
            static let secondItem = "Métodos de pago"
            static let thirdItem = "Editar Gustos"
            static let forthItem = "Cambiar contraseña"
            static let fifthItem = "Cerrar sesión"
        }
        
        struct BigButtom  {
            
        }
        
    }
    
    // MARK:- Storyboards
    struct storyboards {
        static let menu = "Menu"
        static let plan = "Plans"
        static let profile = "Profile"
        static let feed = "Feed"
        static let chat = "Chat"
        static let menuHost = "MenuHost"
        static let feedHost = "FeedHost"
        static let chatHost  = "ChatHost"
        static let profileHost = "ProfileHost"
        static let authHost = "AuthHost"
        
    }
    
    // MARK:- Initial controllers
    struct Instancecontrollers {
        struct Main {
            static let mainTabBarController = "MainTabBarController"
            struct Host {
                static let mainTabBarHostController = "MainTabBarHostController"
            }
        }
        
        struct AuthHost {
            static let validateCodeHostController = "ValidateCodeHostController"
            static let IncompleteStateController = "IncompleteStateController"
            
        }
    
    }
    
    struct NIB {
        static let hourPopup = "LocationPopup"
        static let datePopup = "DatePopup"
        static let alertNoAvailable = "AlertNoAvailable"
        static let alertSetAboutMe = "AlertSetAboutMe"
    }
    
}
