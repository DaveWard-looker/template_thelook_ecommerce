### Intermediate ecommerce Explore file
# This Explore highlights basic UX improvements you can make through:
#   - Renaming, aliasing, or re-labeling objects
#   - Limiting/removing fields from the Explore when fields are in the source table but are not relevant
###

include: "/2_intermediate_lookml/*.view.lkml"

# Tip: Give Explores a meaningful name related to the use case they serve.
# Consider that Explore names appear in URLs, and try to help future developers with a descriptive name.
explore: intermediate_example_ecommerce {
  # Use the `from` parameter to specify what view object to use as the base view,
  # if the view name is different from the Explore name.
  from: intermediate_order_items
  view_name: order_items # Optionally use `view_name` to change how you reference the view in this Explore.
  label: "2) Intermediate Ecommerce" # Change the label used for the Explore in the UI, i.e. the human readable name
  join: users { # Technically, join name sets an alias: how the view joined view will be referred to in this Explore, For example, this aliasing is used when you need two joins to the same view (for example, imagine we have one users table which we want to join twice, for buyer and seller).
    from: intermediate_users #If the join/alias does not match the LookML view name, set the LookML view to use with this from parameter.
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  # Note: @hat users care about is product info.
  # We determined that a join to product requires an intermediate join through inventory_items.
  join: inventory_items {
    from: intermediate_inventory_items
    fields: [inventory_items.product_id, inventory_items.cost,inventory_items.total_cost,inventory_items.average_cost] # We determined most inventory_item fields aren't relevant to our users, so we used the `fields` parameter to show in this Explore only the fields from this join that are necessary and helpful.
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
