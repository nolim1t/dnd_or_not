mongo = require './mongo.coffee'

# USAGE:
# isbusy.log {venueobj: venue, reference: {id: id, userid: user.id, from: 'foursquare'}}, (cb) -> console.log cb
# then check cb.meta.status (should be 200) and cb.busy_status (true or false)

isbusy = (info, cb) ->
	if info.venueobj != undefined and info.reference != undefined
		if info.venueobj.categories != undefined
			# Make sure theres a category
			is_busy = false	
			
			# Place types where I'm most likely not gonna be free in
			busy_categories = [{
				name: "Professional & Other Places",
				all: false, 
				subcategories: ["Convention Center", "Medical Center", "Event Space"]
			},
			{
				name: "Nightlife Spot",
				all: true,
				subcategories: []
			},
			{
				name: "Arts & Entertainment",
				all: false,
				subcategories: ["Movie Theatre"]
			},
			{
				name: "Travel & Transport",
				all: true,
				subcategories: []
			}]
			for category in info.venueobj.categories
				if category.primary != undefined
					if category.primary == true
						for busy_category in busy_categories
							# Iterate through all busy categories
							if busy_category.all == true
								# Pull aside the all ones to check the parent categories
								for parent in category.parents
									if busy_category.name == parent
										# Only if there is a matching parent
										is_busy = true
							else
								# Otherwise inspect the sub categories
								for busy_subcategory in busy_category.subcategories
									if busy_subcategory == category.name
										# We have a match so set the busy status
										is_busy = true
						 				
			cb({meta: {status: 200, msg: "OK Logged"}, busy_status: is_busy})
		else
			# NO CATEGORIES
			cb({meta: {status: 400, msg: "No categories!!!!"}})
	else
		cb({meta: {status: 400, msg: "Missing parameters"}})	
	
module.exports = {
	log: isbusy
}