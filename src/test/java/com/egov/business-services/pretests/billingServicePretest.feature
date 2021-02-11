Feature: Billing Service Pretest

Background:
    * def billingServiceConstants = read('../../business-services/constants/billing-service.yaml')
    * def businessService = billingServiceConstants.parameters.businessService
    * def fetchBillRequest = read('../../business-services/requestPayload/collection-services/fetchBill.json')
    * configure headers = read('classpath:websCommonHeaders.js')

@fetchBill
    Scenario: Fetch Bill
    * def fetchBillParams = 
    """
    {
       consumerCode: '#(consumerCode)',
       businessService: '#(businessService)',
       tenantId: '#(tenantId)'
    }
    """
    Given url fetchBill
    And params fetchBillParams
     * print fetchBillParams
    And request fetchBillRequest
    When method post
    Then status 201
    And def fetchBillResponse = response
    * print fetchBillResponse
    And def totalAmount = response.Bill[0].totalAmount
    And def billId = response.Bill[0].id
    And def txnAmount = totalAmount
     * print billId 
     * print totalAmount

@fetchBillWithCustomizedParameters
    Scenario: Fetch Bill with customized parameters
    Given url fetchBill
    And params fetchBillParams
     * print fetchBillParams
    And request fetchBillRequest
    When method post
    Then def fetchBillResponse = response
     * print fetchBillResponse

@successSearchBill
    Scenario: Search bill with customized parameters
    Given url searchBill
    And params searchBillParams
        * print searchBillParams
    And request fetchBillRequest
    When method post
    Then def searchBillResponse = response
    And assert searchBillResponse != null
    And assert responseStatus == 200 || responseStatus == 400