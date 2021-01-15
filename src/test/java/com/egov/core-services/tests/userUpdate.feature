Feature: Update user

Background:
    * def userProfileData = read('../constants/user.yaml')
    * def city = userProfileData.validProfileData.city
    * def userName = userProfileData.validProfileData.userName
    * def emailId = userProfileData.validProfileData.emailId
    * def errorMessage = read("../constants/user.yaml")

@User_Update_ValidDataWithNameEmailCity_01  @positive   @user
Scenario: To verify user profile data is updating correctly
        * call read('../pretests/updateUserPretest.feature@validParameters')
        * print updatedUserprofileResponseBody.user[0].correspondenceCity
        * print updatedUserprofileResponseBody.user[0].name
        * print updatedUserprofileResponseBody.user[0].emailId
        * assert updatedUserprofileResponseBody.user[0].correspondenceCity == city
        * assert updatedUserprofileResponseBody.user[0].name == userName
        * assert updatedUserprofileResponseBody.user[0].emailId == emailId

@User_Update_ValidDataWithAlltheParameters_02   @positive   @user
Scenario: Update existing user profile with all valid parameters
   * call read('../pretests/updateUserPretest.feature@validAllParameters')
   

@User_Update_NameWithSpecialCharacters_03  @negative    @user
Scenario: To verify the error message returned by API when an invalid username is passed
        * call read('../pretests/updateUserPretest.feature@inValidUserName')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.missMatchError

@User_Update_InvalidEmail_04  @negative @user
Scenario: To verify the error message returned by API when an invalid emailid is passed
        * call read('../pretests/updateUserPretest.feature@inValidEmailId')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.invalidEmailError

@User_Update_InvalidMobileNumber_05  @negative  @user
Scenario: To verify the error message returned by API when an invalid phone number is passed
        * call read('../pretests/updateUserPretest.feature@inValidPhoneNumber')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.invalidPhoneNumberError

@User_Update_RandomDigit_MobileNumber_06  @negative @user
Scenario: To verify the phone number is not get updated even though it is valid
        * call read('../pretests/updateUserPretest.feature@validRandomPhoneNumber')
        * print updatedUserprofileResponseBody.user[0].mobileNumber
        * assert updatedUserprofileResponseBody.user[0].mobileNumber != userProfileData.inValidProfileData.mobileNumber 

@User_Update_InvalidGender_07  @negative    @user
Scenario: To verify the error message returned by API when an invalid gender is passed
        * call read('../pretests/updateUserPretest.feature@invalidGender')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.invalidGenderError  

@User_Update_noTenantId_08  @negative   @user
Scenario: To verify the error message returned by API when tenant id passed as null
        * call read('../pretests/updateUserPretest.feature@invalidTenantId')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.tenantIdNull 

@User_Update_noUUID_09  @negative   @user
Scenario: To verify the error message returned by API when UUID passed as blank
        * call read('../pretests/updateUserPretest.feature@blankUUID')
        * print updatedUserprofileResponseBody.Errors[0].code
        * assert updatedUserprofileResponseBody.Errors[0].code == errorMessage.errorMessages.noUUIDErrorCode

@User_Update_InvalidUUID_10  @negative  @user
Scenario: To verify the error message returned by API when an invalid UUID passed
        * call read('../pretests/updateUserPretest.feature@invalidUUID')
        * print updatedUserprofileResponseBody.Errors[0].code
        * assert updatedUserprofileResponseBody.Errors[0].code == errorMessage.errorMessages.noUUIDErrorCode 

@User_Update_noID_11  @negative @user
Scenario: To verify the error message returned by API when ID is removed
        * call read('../pretests/updateUserPretest.feature@removeID')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.tenantIdNull  

@User_Update_InvalidID_12  @negative    @user
Scenario: To verify the error message returned by API when ID is invalid
        * call read('../pretests/updateUserPretest.feature@invalidID')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.tenantIdNull

@User_Update_NameWithMorethanMaxCharacters_13  @negative    @user
Scenario: To verify the max length of characters of username
        * call read('../pretests/updateUserPretest.feature@nameWithMaxmiumCharacters')
        * print updatedUserprofileResponseBody.Errors[0].message
        * assert updatedUserprofileResponseBody.Errors[0].message == errorMessage.errorMessages.usernameLengthError 
     