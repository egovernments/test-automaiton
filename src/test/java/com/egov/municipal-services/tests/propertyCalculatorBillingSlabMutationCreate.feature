Feature: To test property-calculator-billingSlabs-mutation service 'Create' endpoint

Background: 
    * def jsUtils = read('classpath:jsUtils.js')
    * def propertyCalculatorConstants = read('../../municipal-services/constants/propertyCalculator.yaml')
    * def commonConstants = read('../../common-services/constants/genericConstants.yaml')
    * def propertyType = mdmsStatePropertyTax.PropertyType[0].code
    * def propertySubType = mdmsStatePropertyTax.PropertySubType[0].code
    * def usageCategoryMajor = mdmsStatePropertyTax.UsageCategoryMajor[0].code
    * def usageCategoryMinor = mdmsStatePropertyTax.UsageCategoryMinor[0].code
    * def usageCategorySubMinor = mdmsStatePropertyTax.UsageCategorySubMinor[0].code
    * def usageCategoryDetail = mdmsStatePropertyTax.UsageCategoryDetail[0].code
    * def ownerShipCategory = mdmsStatePropertyTax.OwnerShipCategory[0].code
    * def subOwnerShipCategory = mdmsStatePropertyTax.SubOwnerShipCategory[0].code
    * def minMarketValue = ranInteger(1)+.0
    * def maxMarketValue = ranInteger(3)+.0
    * def fixedAmount = ranInteger(4)+.0
    * def rate = ranInteger(2)+.0
    * def type = "FLAT"
    * def invalidTenaniId = 'invalid'+randomString(3)
    * def nullFixedAmountError =  propertyCalculatorConstants.errorMessage.nullFixedAmount
    * def nullRateError =  propertyCalculatorConstants.errorMessage.nullRate
    * def createBillingSlabMutationPayload = read('../../municipal-services/requestPayload/property-calculator/mutationBillingSlab/create.json')

@BillingSlabMutation_Create_01
Scenario: Verify creating a mutation billing slab for property tax through API call
    * call read('../../municipal-services/pretests/propertyCalculatorServicesPretest.feature@createBillingSlabMutation')
    * match mutationCreateResponse.ResponseInfo.status == commonConstants.expectedStatus.success
    * match mutationCreateResponse.MutationBillingSlab[0].propertyType == propertyType
    * match mutationCreateResponse.MutationBillingSlab[0].propertySubType == propertySubType
    * match mutationCreateResponse.MutationBillingSlab[0].usageCategoryMajor == usageCategoryMajor
    * match mutationCreateResponse.MutationBillingSlab[0].usageCategoryMinor == usageCategoryMinor
    * match mutationCreateResponse.MutationBillingSlab[0].usageCategorySubMinor == usageCategorySubMinor
    * match mutationCreateResponse.MutationBillingSlab[0].usageCategoryDetail == usageCategoryDetail
    * match mutationCreateResponse.MutationBillingSlab[0].ownerShipCategory == ownerShipCategory
    * match mutationCreateResponse.MutationBillingSlab[0].subOwnerShipCategory == subOwnerShipCategory
    * match mutationCreateResponse.MutationBillingSlab[0].minMarketValue == minMarketValue
    * match mutationCreateResponse.MutationBillingSlab[0].maxMarketValue == maxMarketValue
    * match mutationCreateResponse.MutationBillingSlab[0].fixedAmount == fixedAmount
    * match mutationCreateResponse.MutationBillingSlab[0].rate == rate
    * match mutationCreateResponse.MutationBillingSlab[0].type == type

@BillingSlabMutation_create_InValidTenant_02
Scenario: Verify creating a mutation billing slab for property tax through API call by passing an invalid or non existant tenant id and check for error
    * set createBillingSlabMutationPayload.MutationBillingSlab[0].tenantId = invalidTenaniId
    * call read('../../municipal-services/pretests/propertyCalculatorServicesPretest.feature@errorInCreateBillingSlabMutation')
    * match mutationCreateResponse.Errors[0].message == commonConstants.errorMessages.authorizedError

@BillingSlabMutation_Create_nullValues_03
Scenario: Verify creating a mutation billing slab for property tax by passing null values in the request
    * set createBillingSlabMutationPayload.MutationBillingSlab[0].fixedAmount = null
    * set createBillingSlabMutationPayload.MutationBillingSlab[0].rate = null
    * call read('../../municipal-services/pretests/propertyCalculatorServicesPretest.feature@errorInCreateBillingSlabMutation')
    * print mutationCreateResponse
    * match mutationCreateResponse.Errors[*].code contains ['#(nullFixedAmountError)', '#(nullRateError)']