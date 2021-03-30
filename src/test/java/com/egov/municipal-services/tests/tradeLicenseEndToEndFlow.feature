Feature: Trade License Service - End to End Flow

Background:
    * def jsUtils = read('classpath:jsUtils.js')
    * def commonConstants = read('../../common-services/constants/genericConstants.yaml')
    * def userOtpConstant = read('../../core-services/constants/userOtp.yaml')
    * def tlCalculatorConstants = read('../../municipal-services/constants/tlCalculator.yaml')

###########################
#    TODO: Need to revisit the below tests where Payment needs to be made through third party payment gateway
#        @crateTradeLicenseAndApproveCitizen
#        @crateTradeLicenseAndCancelAfterApproveCitizen
#        @crateTradeLicenseAndEditRenewalCitizen
#        @crateTradeLicenseAndSendForRenewalCitizen
###########################


@createTradeLicenseAndApproveCitizen @positive @regression
Scenario: Login as a citizen, create, approve and make payment for TL
     # Steps to validate error messages of login attempt with invalid mobile number
    * call read('../../core-services/pretests/userOtpPretest.feature@errorInvalidMobileNo')
    * assert userOtpSendResponseBody.error.fields[0].code == userOtpConstant.errorMessages.msgForMobileNoLength
    * assert userOtpSendResponseBody.error.fields[0].message == userOtpConstant.errorMessages.msgForValidMobNo
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    # Steps to login as Citizen and do payment
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBill')
    * def totalAmount = fetchBillResponse.Bill[0].totalAmount
    # Steps to initiate Payment
    #TODO : Need to add Trade License Payment steps through Third party payment gateway
    * call read('../../core-services/pretests/pgServiceCreate.feature@createPgTransactionSuccessfully')

@editAsDocVerifier @positive @regression
Scenario: Edit as Doc-Verifier
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    * def tradeLicenseApplicationNumber = tradeLicenseResponseBody.Licenses[0].applicationNumber
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')

@rejectAsDocVerifier @positive @regression
Scenario: Reject as Doc-Verifier
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    # Steps to login as DocumentVerifier and Reject a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@rejectTLAsdocVer')
    * match tradeLicenseResponseBody.Licenses[0].status == 'REJECTED'

@editAsFieldInspector @positive @regression
Scenario: Edit as Field Inspector
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    * def tradeLicenseApplicationNumber = tradeLicenseResponseBody.Licenses[0].applicationNumber
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')

@rejectAsFieldInspector @positive @regression
Scenario: Reject as Field Inspector
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    # Steps to login as FieldInspector and Reject a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@rejectTLAsFieldInspector')
    * match tradeLicenseResponseBody.Licenses[0].status == 'REJECTED'

@sendBackToCitizenAsFieldInspector @positive @regression
Scenario: Send Back to Citizen as Field Inspector
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    # Steps to login as FieldInspector and Send Back to CITIZEN
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@sendBackToCitizenFromFieldInspector')
    * match tradeLicenseResponseBody.Licenses[0].status == 'CITIZENACTIONREQUIRED'
    # Steps to login as Citizen and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@updateTL_Only')

@sendBackToDocVerifierAsFieldInspector @positive @regression
Scenario: Send Back to Doc Verifier as Field Inspector
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    # Steps to login as FieldInspector and Send Back to DocVerifier
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@sendBackToDocVerifierFromFieldInspector')

@rejectAsApprover @positive @regression
Scenario: Reject as Approver
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Reject a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@rejectTLAsApprover')
    * match tradeLicenseResponseBody.Licenses[0].status == 'REJECTED'

@sendBackToFieldInspectorAsApprover @positive @regression
Scenario: Send Back to Field Inspector as Approver
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Send Back to FieldInspector
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@sendBackToFieldInspectorFromApprover')
    * match tradeLicenseResponseBody.Licenses[0].status == 'FIELDINSPECTION'

@createTradeLicenseAndApproveCounterEmployee @positive @regression
Scenario: Login as a CounterEmployee, create, approve and make payment for TL
    # Steps to login as Counter Employee and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    # Steps to login as Counter Employee and do Payment
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment') 
    * def consumerCode = collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.consumerCode
    * def receiptNumber = collectionServicesResponseBody.Payments[0].paymentDetails[0].receiptNumber
    * match collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.status == 'ACTIVE'
    * def key = 'tradelicense-receipt'
    #Download Receipt
    * call read('../../core-services/pretests/pdfServiceCreate.feature@createPdfSuccessfully')



@createTradeLicenseAndCancelAfterApproveCounterEmployee @positive @regression
Scenario: Login as a CounterEmployee, make payment for TL and cancel the Application
    # Steps to login as Counter Employee and Create a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    # Steps to login as Counter Employee and do Payment
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * def consumerCode = tradeLicense.applicationNumber
    * def tradeLicenseApplicationNumber = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment')
    # Steps to login as Approver and Cancel the application
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch') 
    * call read('../../municipal-services/tests/tradeLicense.feature@cancelTL')

@createTradeLicenseAndCancelAfterApproveCitizen @positive @regression
Scenario: Login as a citizen, make payment for TL and Cancel the Application
    # Steps to login as Citizen and Create a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    #TODO : Need to add Trade License Payment steps through Third party payment gateway

    # Steps to login as Approver and Cancel the application
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch') 
    * call read('../../municipal-services/tests/tradeLicense.feature@cancelTL')

@createTradeLicenseAndSubmitForRenewalCounterEmployee @positive @regression
Scenario: Login as a CounterEmployee, Submit for Renewal and make payment for TL
    # Steps to login as Counter Employee and Create a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment')  
    * def receiptNumber = collectionServicesResponseBody.Payments[0].paymentDetails[0].receiptNumber
    * match collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.status == 'ACTIVE'
    * def key = 'tradelicense-receipt'
    * call read('../../core-services/pretests/pdfServiceCreate.feature@createPdfSuccessfully')
    # Steps to login as Counter Employee and Submit for Renewal
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')
    * call read('../../municipal-services/tests/tradeLicense.feature@submitRenewal')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    # Steps to login as Counter Employee and do Payment
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment')  
    * def receiptNumber = collectionServicesResponseBody.Payments[0].paymentDetails[0].receiptNumber
    * match collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.status == 'ACTIVE'
    * def key = 'tradelicense-receipt'
    * call read('../../core-services/pretests/pdfServiceCreate.feature@createPdfSuccessfully')

@createTradeLicenseAndEditForRenewalCounterEmployee @positive @regression
Scenario: Login as a CounterEmployee, Edit for Renewal and make payment for TL
    # Steps to login as Counter Employee and Create a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment')  
    * def receiptNumber = collectionServicesResponseBody.Payments[0].paymentDetails[0].receiptNumber
    * match collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.status == 'ACTIVE'
    * def key = 'tradelicense-receipt'
    * call read('../../core-services/pretests/pdfServiceCreate.feature@createPdfSuccessfully')
    # Steps to login as Counter Employee and EDIT for Renewal
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')
    * call read('../../municipal-services/tests/tradeLicense.feature@editRenewal')
    * def tradeLicense = tradeLicenseResponseBody.Licenses[0]
    # Approve Again and do Payment
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * call read('../../municipal-services/tests/tradeLicense.feature@updateTLAfterEdit')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCounterEmployee')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * def fetchBillParams = {tenantId: '#(tenantId)',consumerCode: '#(consumerCode)', businessService: '#(businessService)'}
    # Steps to fetch the bill details
    * call read('../../business-services/pretest/billingServicePretest.feature@fetchBillWithCustomizedParameters')
    * call read('../../business-services/pretest/collectionServicesPretest.feature@createPayment')  
    * def receiptNumber = collectionServicesResponseBody.Payments[0].paymentDetails[0].receiptNumber
    * match collectionServicesResponseBody.Payments[0].paymentDetails[0].bill.status == 'ACTIVE'
    * def key = 'tradelicense-receipt'
    * call read('../../core-services/pretests/pdfServiceCreate.feature@createPdfSuccessfully')

@createTradeLicenseAndSendForRenewalCitizen @positive @regression
Scenario: Login as a citizen and Send for Renewal
    # Steps to login as Citizen and Create a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL'
    # Steps to login as DocumentVerifier and Update a Trade License)
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    #TODO : Need to add Trade License Payment steps through Third party payment gateway

    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')
    * call read('../../municipal-services/tests/tradeLicense.feature@submitRenewal')
    #TODO : Need to add Trade License Payment steps through Third party payment gateway

@createTradeLicenseAndEditRenewalCitizen @positive @regression
Scenario: Login as a citizen and EditRenewal 
    # Steps to login as Citizen and Create a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@createAndupdateTL')
    # Steps to login as DocumentVerifier and Update a Trade License) 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenDocVerifierTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@docVerTL')
    # Steps to login as FieldInspector and Update a Trade License 
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenFieldInspectorTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@fiTL')
    # Steps to login as Approver and Approve a Trade License
    * call read('../../common-services/pretests/authenticationToken.feature@authTokenApproverTL')
    * call read('../../municipal-services/tests/tradeLicense.feature@approveTL')
    * def consumerCode = tradeLicense.applicationNumber
    * def businessService = tradeLicense.businessService
    * print consumerCode
    #TODO : Need to add Trade License Payment steps through Third party payment gateway

    * call read('../../common-services/pretests/authenticationToken.feature@authTokenCitizen')
    * call read('../../municipal-services/tests/tradeLicense.feature@tradeLicenseSearch')
    * call read('../../municipal-services/tests/tradeLicense.feature@editRenewal')

