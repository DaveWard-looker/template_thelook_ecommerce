### Intermediate ecommerce validated Explore file
# This Explore is nearly identical to intermediate_example_ecommerce Explore,
# EXCEPT that we were directed to make a separate Explore that ALWAYS EXCLUDES items that are not 'Valid'.
#
# This Explore uses Explore-level parameters like `sql_always_where`, `always_filter`, `fields`, and `labels`, as needed for this context.
#
# KEY CONCEPT: Notice that we are using the same LookML views (with the `from: intermediate_order_items` statement) that were used by the intermediate_example_ecommerce Explore.
# LookML helps us to be consistent becase we don't redefine those views from scratch.
###

include: "/2_intermediate_lookml/*.view.lkml"

explore: intermediate_example_ecommerce_validated_orders {
  sql_always_where: ${order_items.validation_status} = "Valid" ;; # Use `sql_always_where` to force filtration to be added to every query, without any related UI filter.
  always_filter: {filters:[order_items.validation_status: ""]} # Use `always_filter` to enforce important filters to be presented to the user in the filter bar of the Explore. These filters are editable by the user, unlike with `sql_always_where`.
  fields: [ALL_FIELDS*,-order_items.innapropriate_fields_for_valid_only_explores*] # Fields or sets of fields can be removed entirely from Explores this way. In this case, we are already filtering the all data in the Explore such that it doesn't make sense to include cancelllation type for selection.
  from: intermediate_order_items
  view_name: order_items
  label: "3) Intermediate Ecommerce (Valid Orders only)"

  join: users {
    from: intermediate_users
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: inventory_items {
    from: intermediate_inventory_items
    fields: [inventory_items.product_id, inventory_items.cost,inventory_items.total_cost,inventory_items.average_cost] # We determined most intermediate_inventory_items fields aren't relevant to our users, so we used the `fields` parameter to show in this Explore only the fields from this join that are necessary and helpful.
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: products {
    from: intermediate_products
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
