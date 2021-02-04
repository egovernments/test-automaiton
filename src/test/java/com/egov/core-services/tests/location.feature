Feature: Location

Background:
  * def jsUtils = read('classpath:jsUtils.js')
  
  
  
  
  * def locationPayload = read('../../core-services/requestPayload/location/searchLocation.json')
  * print location
  * def locationConstant = read('../../core-services/constants/location.yaml')
  * def commonConstants = read('../../common-services/constants/genericConstants.yaml')
  

@SearchLocation_01  @Positive  @location
Scenario: Send a POST request for a given tenant Id to search for the location details
      * def hierarchyTypeCode = mdmsCityTenantBoundary[0].hierarchyType.code
      * def boundaryType = mdmsCityTenantBoundary[0].boundary.children[0].children[0].children[0].label
      * print boundaryType
      * call read('../../core-services/pretests/location.feature@locationsuccess')
      * print searchLocationResponseBody
      * match searchLocationResponseBody == '#present'

@SearchLocation_NoTenantId_02  @Negative  @location
Scenario: Search for  location details without tenantId
      * def hierarchyTypeCode = mdmsCityTenantBoundary[0].hierarchyType.code
      * def boundaryType = mdmsCityTenantBoundary[0].boundary.children[0].children[0].children[0].label
      * call read('../../core-services/pretests/location.feature@locationwithnotenantid')
      * print searchLocationResponseBody
      * assert searchLocationResponseBody.Errors[0].message == locationConstant.errorMessages.noTenantId

@SearchLocation_NonExistentValues_03  @Negative  @location
Scenario: Send a POST request by passing  invalid/ non existent tenantId and search for the location details
      * def hierarchyTypeCode = mdmsCityTenantBoundary[0].hierarchyType.code
      * def boundaryType = mdmsCityTenantBoundary[0].boundary.children[0].children[0].children[0].label
      * def tenantId = commonConstants.invalidParameters.invalidTenantId
      * call read('../../core-services/pretests/location.feature@locationsuccess')
      * print searchLocationResponseBody
      * match searchLocationResponseBody == '#present'

@SearchLocation_MultiplehierarchyTypeCode_04  @Positive  @location
Scenario: Send a POST request by passing Multiple hierarchyTypeCode and search for the location details for a particular Tenant
      * def hierarchyTypeCode = mdmsCityTenantBoundary[0].hierarchyType.code + ',' + mdmsCityTenantBoundary[1].hierarchyType.code
      * def boundaryType = mdmsCityTenantBoundary[0].boundary.children[0].children[0].children[0].label
      * call read('../../core-services/pretests/location.feature@locationsuccess')
      * print searchLocationResponseBody
      * match searchLocationResponseBody == '#present'   

@SearchLocation_AllRecords_05  @Positive  @location
Scenario: Search to fetch all the records for a particular tenant
      * call read('../../core-services/pretests/location.feature@locationsuccesswithtenantid')
      * print searchLocationResponseBody
      * match searchLocationResponseBody == '#present'  
      
@SearchLocation_MulltipleTenantId_08  @Negative  @location
Scenario: Send a POST request by passing multiple tenants which are valid in the request
      * def hierarchyTypeCode = mdmsCityTenantBoundary[0].hierarchyType.code + ',' + mdmsCityTenantBoundary[1].hierarchyType.code
      * def boundaryType = mdmsCityTenantBoundary[0].boundary.children[0].children[0].children[0].label
      * def tenantId = mdmsCityTenant.tenants[1].code + ',' + mdmsCityTenant.tenants[3].code
      * call read('../../core-services/pretests/location.feature@locationsuccess')
      * print searchLocationResponseBody
      * match searchLocationResponseBody == '#present'





