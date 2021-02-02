Feature: MDMS Service

Background:
  * def jsUtils = read('classpath:jsUtils.js')
  * def searchCityRequest = read('../../common-services/requestPayload/egov-mdms/searchCity.json')
  * def searchStateRequest = read('../../common-services/requestPayload/egov-mdms/searchState.json')
  * configure headers = read('classpath:websCommonHeaders.js')

@successSearchState
Scenario: Search MDMS by State success Call
  Given url searchMdmsUrl
  * print searchMdmsUrl
  And request searchStateRequest
  * print searchStateRequest
  When method post
  Then status 200
  And def mdmsServiceResponseHeader = responseHeaders
  And def mdmsServiceResponseBody = response
  And def MdmsStateRes = mdmsServiceResponseBody.MdmsRes
  And def PropertyTax = MdmsStateRes.PropertyTax
  And def tenant = MdmsStateRes.tenant
  And def BillingService = MdmsStateRes.BillingService
  And def commonMasters = MdmsStateRes['common-masters']
  And def accessControlRoles = MdmsStateRes['ACCESSCONTROL-ROLES']
  And def egovHrms = MdmsStateRes['egov-hrms']
  And def billingService = MdmsStateRes['BillingService']
  And def dashboard = MdmsStateRes['dss-dashboard']
  And def dashboardConfig = dashboard['dashboard-config'][0].MODULE_LEVEL

@successSearchCity
Scenario: Search MDMS by State and city success Call
  Given url searchMdmsUrl
  * print searchMdmsUrl
  And request searchCityRequest
  * print searchCityRequest
  When method post
  Then status 200
  And def mdmsServiceResponseHeader = responseHeaders
  And def mdmsServiceResponseBody = response
  And def mdmsServiceResponseHeader = responseHeaders
  And def mdmsServiceResponseBody = response
  And def MdmsCityRes = mdmsServiceResponseBody.MdmsRes
  And def egovLocation = MdmsCityRes['egov-location']
  And def tenantBoundary = MdmsCityRes['egov-location'].TenantBoundary
  And def tenant = MdmsCityRes.tenant
