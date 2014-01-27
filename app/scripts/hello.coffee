class Logger
    log: (title, anObject) -> $("#output").append """
        <li class="list-group-item">
            <h4 class="list-group-item-heading">#{title}</h4>
            <pre class="list-group-item-text">#{@stringify anObject}</p>
        </li>
    """

    stringify: (anObject) ->
        json = JSON.stringify(anObject, `undefined`, 2)  unless typeof json is "string"
        json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
        json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
            cls = "number"
            if /^"/.test(match)
              if /:$/.test(match)
                cls = "key"
              else
                cls = "string"
            else if /true|false/.test(match)
              cls = "boolean"
            else cls = "null"  if /null/.test(match)

            "<span class=\"" + cls + "\">" + match + "</span>"

class EntitiesHome extends $.RestClient
    constructor: (baseUrl, accessToken) ->
        super baseUrl
        @opts.ajax.contentType = "application/json"
        @opts.ajax.beforeSend = (req) -> req.setRequestHeader 'Authorization', "Basic #{accessToken}"
        @opts.stringifyData = true

        @add resource for resource in @resources()

        @salesOrders.add 'shipments'
        @salesOrders.add 'payments'

        @logger = new Logger()

    resources: -> [
        'products', 'categories', 'brands', 'expensecategories', 'contacts', 'accounts',
        'expenseitems', 'expenses', 'transfers', 'purchases', 'sales', 'payments', 'collections',
        'salesOrders', 'purchaseorders', 'warehouses'
    ]

    log: (title, entity) -> @logger.log title, entity

    createAndLog: (resource, entity) ->
        @[resource].create(entity)
            .done (entityId) => @readAndLog resource, entityId

    readAndLog: (resource, id) ->
        @[resource].read(id).done (entity) =>
            @log "#{resource} ##{id}:", entity

home = new EntitiesHome "http://localhost/api/", "ew0KICAiSXYiOiAiWjdvYWJ6UHZCRHplWmhzbDFpMlErQT09IiwNCiAgIkRhdGEiOiAiWTVWdUMxcnZsWEpIWk00R081QVIxQT09Ig0KfQ=="

hiddenTreeWarehouse =
    name: "Hidden tree warehouse"

home.createAndLog("warehouses", hiddenTreeWarehouse).done (warehouseId) ->
    teaPot =
        description: "Tea pot"
        warehouses: [
            warehouse: warehouseId
            quantity: 25
        ]
    home.createAndLog("products", teaPot).done (teaPotId) ->
        theMadHatter =
            description: "The mad hatter"
        home.createAndLog("contacts", theMadHatter).done (theMadHatterId) ->
            salesOrder =
                contact: theMadHatterId
                lines: [
                    product: teaPotId
                    quantity: 20
                    price: 10
                ]
                wareHouse: warehouseId

            home.createAndLog("salesOrders", salesOrder).done (salesOrderId) ->
                shipment =
                    date: "2013-12-13"
                    products: [
                        product: teaPotId
                        quantity: 20
                    ]

                payment =
                    date: "2013-12-13"
                    amount: 190.5


                purchasesOrder =
                    contact: theMadHatterId
                    date: '11/18/2013'
                    lines: [
                        product: teaPotId
                        quantity: 100
                        price: 9
                    ]
                    wareHouse: warehouseId

                home.createAndLog("purchaseorders", purchasesOrder).done (purchaseorderId) ->

                    $.when(home.salesOrders.shipments.create(salesOrderId, shipment), home.salesOrders.payments.create(salesOrderId, payment))
                        .done ->
                            home.readAndLog "salesOrders", salesOrderId
                            home.readAndLog "purchaseorders", purchaseorderId
                            home.readAndLog "warehouses", warehouseId
                            home.readAndLog "contacts", theMadHatterId
