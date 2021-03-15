Feature: Property Service 

Background: 
  * def createPropertyRequest = read('../../municipal-services/requestPayload/property-services/create.json')
  * def updatePropertyRequest = read('../../municipal-services/requestPayload/property-services/update.json')
  * def assessmentRequest = read('../../municipal-services/requestPayload/property-services/createAssessment.json')
  * def searchPropertyRequest = read('../../common-services/requestPayload/common/search.json')

@createPropertySuccessfully 
Scenario: Create a property successfully 
	Given url createpropertyUrl 
	And request createPropertyRequest
	When method post 
	Then status 201 
	And def propertyServiceResponseHeaders = responseHeaders 
	And def propertyServiceResponseBody = response 
	And def Property = propertyServiceResponseBody.Properties[0] 
	And def propertyId = Property.propertyId 
	And def consumerCode = propertyId 
	And def acknowldgementNumber = Property.acknowldgementNumber 
	And def businessId = acknowldgementNumber 
	
@errorInCreateProperty 
Scenario: Create a property error 
	Given url createpropertyUrl 
	And request createPropertyRequest 
	When method post 
	Then assert responseStatus >=400 && responseStatus <=403 
	And def propertyServiceResponseHeaders = responseHeaders 
	And def propertyServiceResponseBody = response 
	
@errorInCreatePropertyRemoveField 
Scenario: Create a property error 
	Given url createpropertyUrl 
	* eval karate.remove('createPropertyRequest', removeFieldPath) 
	And  request createPropertyRequest 
	When  method post 
	Then  assert responseStatus >=400 && responseStatus <=403 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	
	
@searchPropertySuccessfully 
Scenario: Search a property 
	Given  url searchPropertyUrl 
	And  params searchPropertyParams 
	And  request searchPropertyRequest 
	When  method post 
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response
  And def Property = propertyServiceResponseBody.Properties[0]
  And def propertyId = Property.propertyId 
	And def consumerCode = propertyId 
	And def acknowldgementNumber = Property.acknowldgementNumber 
	And def businessId = acknowldgementNumber 

@searchPropertyForEmptyResult 
Scenario: Search a property for empty result
	Given  url searchPropertyUrl 
	And  params searchPropertyParams 
	And  request searchPropertyRequest 
	When  method post 
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response

@errorInSearchProperty 
Scenario: Search a property error 
	Given  url searchPropertyUrl 
	And  params searchPropertyParams 
	And  request searchPropertyRequest 
	When  method post 
	Then  status 400 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	
@updatePropertySuccessfully 
Scenario: Update a property 
	* def workflow = updatePropertyRequest.Property.workflow 
	* eval Property = karate.merge(Property, {'0': {'comment': '', 'assignee':[]}}) 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	* eval updatePropertyRequest.Property.workflow.action = 'VERIFY'
  Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	And  def Property = propertyServiceResponseBody.Properties[0] 
	And  def propertyId = Property.propertyId 
	And  def consumerCode = propertyId 

@errorInUpdateProperty
Scenario: Update a property error
	* def workflow = updatePropertyRequest.Property.workflow 
	* eval Property = karate.merge(Property, {'0': {'comment': '', 'assignee':[]}}) 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	* eval updatePropertyRequest.Property.workflow.action = 'VERIFY'
  Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post
	Then  assert responseStatus >=400 && responseStatus <=403 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response

@errorInUpdatePropertyRemoveField
Scenario: Update a property error
	* def workflow = updatePropertyRequest.Property.workflow 
	* eval Property = karate.merge(Property, {'0': {'comment': '', 'assignee':[]}}) 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	* eval updatePropertyRequest.Property.workflow.action = 'VERIFY'
  * eval karate.remove('updatePropertyRequest', removeFieldPath) 
  Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post
	Then  assert responseStatus >=400 && responseStatus <=403 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response
	
@verifyPropertySuccessfully 
Scenario: Verify a property 
	* def workflow = updatePropertyRequest.Property.workflow 
	# * eval Property = karate.merge(Property, {'0': {'comment': '', 'assignee':[]}}) 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	# Since the action is specifically 'verify', it is hardcoded
	* eval updatePropertyRequest.Property.workflow.action = 'VERIFY' 
	Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post 
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	And  def Property = propertyServiceResponseBody.Properties[0] 
	And  def propertyId = Property.propertyId 
	And  def consumerCode = propertyId 
	
@forwardPropertySuccessfully 
Scenario: Forward a property 
	* def workflow = updatePropertyRequest.Property.workflow 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	* eval updatePropertyRequest.Property.workflow.action = 'FORWARD' 
	Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post 
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	And  def Property = propertyServiceResponseBody.Properties[0] 
	And  def propertyId = Property.propertyId 
	And  def consumerCode = propertyId 
	
@approvePropertySuccessfully 
Scenario: Approve a property 
	* def workflow = updatePropertyRequest.Property.workflow 
	* eval updatePropertyRequest.Property = Property 
	* eval updatePropertyRequest.Property.workflow = workflow 
	* eval updatePropertyRequest.Property.workflow.action = 'APPROVE' 
	Given  url updatePropertyUrl 
	And  request updatePropertyRequest 
	When  method post 
	Then  status 200 
	And  def propertyServiceResponseHeaders = responseHeaders 
	And  def propertyServiceResponseBody = response 
	And  def Property = propertyServiceResponseBody.Properties[0] 
	And  def propertyId = Property.propertyId 
	And  def consumerCode = propertyId 
	
@createAssessmentSuccessfully 
Scenario: Create assessment 
	* def assessmentParams = 
	"""
    {
       tenantId: '#(tenantId)'
    }
    """
	Given  url createAssessment 
	And  params assessmentParams 
	And  request assessmentRequest 
	When  method post 
	Then  status 201
	And   def assessmentResponse = response