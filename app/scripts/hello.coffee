class EntitiesHome extends $.RestClient
	constructor: (baseUrl, accessToken) ->
		super baseUrl		
		@opts.ajax.contentType = "application/json"
		@opts.ajax.beforeSend = (req) -> req.setRequestHeader 'Authorization', "Basic #{accessToken}"
		@opts.stringifyData = true

		@add resource for resource in @resources()

	resources: -> [
		'products', 'categories', 'brands', 'expensecategories', 'contacts', 'accounts', 
		'expenseitems', 'expenses', 'transfers', 'purchases', 'sales', 'payments', 'collections',
		'salesOrders', 'purchaseorders', 'warehouses'
	]

	log: (title, body) -> $("#output").append """
		<li class="list-group-item">
			<h4 class="list-group-item-heading">#{title}</h4>
			<p class="list-group-item-text">#{body}</p>
		</li>
	"""

	createAndLog: (resource, entity) ->
		@[resource].create(entity)
			.always (entityId) => @readAndLog resource, entityId

	readAndLog: (resource, id) ->
		@[resource].read(id).always (entity) => 
			@log "Created #{resource} with id #{id}:", JSON.stringify(entity)

home = new EntitiesHome "http://localhost/api/", "ew0KICAiSXYiOiAiR0xnM1paZkVqcnJhQlZCWE50cjlsUT09IiwNCiAgIkRhdGEiOiAidU1SbVhjSUtUNmk2STF1cjNUaEpRMFh5cnpaZkRkQThKWlFjbDh3V2x5MW8xcGVLZTZWWlpiS3VVWFBqeVFjbzNrbXg3WjU5ZXZCVWZYVElCU0xFTlE9PSINCn0="

home.createAndLog("products", description: "Tea pot").always (teaPotId) ->
	hiddenTreeWarehouse =
		description: "Hidden tree warehouse"
		stocks: [
			product: teaPotId
			quantity: 25
		]	

	home.createAndLog("warehouses", hiddenTreeWarehouse).always (warehouseId) ->
		theMadHatter =
			description: "The mad hatter"

		home.createAndLog("contacts", theMadHatter).always (theMadHatterId) ->
			salesOrder = 
				contact: theMadHatterId
				lines: [
					product: teaPotId
					quantity: 20
					price: 203
				]
				wareHouse: warehouseId

			home.createAndLog("salesOrders", salesOrder)