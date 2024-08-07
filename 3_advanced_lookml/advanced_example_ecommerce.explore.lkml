### Advanced example ecommerce Explore file
# See the ADVANCED_LOOKML_README.md document for overall concepts, more details on specific parameters and techniques used, and the business scenario.
###

include: "/2_intermediate_lookml/intermediate_example_ecommerce.explore.lkml" # We're going to base our Explore on the existing intermediate_example_ecommerce Explore

include: "/1_basic_lookml/basic_users.view.lkml" # Instead of the intermediate_users view, we want to use the basic_users view, so we need to include basic_users here.

include: "/3_advanced_lookml/advanced_order_items.view.lkml"
include: "/3_advanced_lookml/priority_item_filter_feature_support.view.lkml"
include: "/3_advanced_lookml/user_summary_and_order_items_fields.view.lkml"
include: "/3_advanced_lookml/user_summary_unfiltered.view.lkml"
include: "/3_advanced_lookml/user_summary_filtered.view.lkml"

explore: advanced_example_ecommerce {
  extends: [intermediate_example_ecommerce] # We'll use an `extends` parameter to reuse the Explore logic that
  # we already defined in the `intermediate_example_ecommerce.explore`` file. The inventory_items and products views
  # are brought in by extension, since they are joined into the intermediate_example_ecommerce Explore.
  # We don't need to join them in again here unless we want to modify something in those views.

  label: "4) Advanced Ecommerce (Valid Orders only)"
  hidden: no

  from: advanced_order_items
  # This `from` parameter updates the base view of the Explore from
  # the base view that is defined in the `intermediate_example_ecommerce.explore` file.
  # The `advanced_example_ecommerce` Explore uses the `advanced_order_items` base view,
  # which is a more advanced version of the view that has some additional features

  sql_always_where: ${order_items.validation_status} = "Valid"
    and ${priority_item_filter_feature_support.meets_priority_parameter_selection} ;;
  # This `sql_always_where` parameter adds a filter to every query. The filter does the following:
  # 1) Ensures that only 'Valid' items are included
  # 2) Supports the custom 'High Value Only' toggle that is requested in this business scenario


  always_filter: {filters:[priority_item_filter_feature_support.priority_items_only_toggle: "AllItems"]} # This sets a default in UI for the special filter toggle.

  fields: [ALL_FIELDS*,-order_items.innapropriate_fields_for_valid_only_explores*]
  # Because we're filtering to 'Valid' only, we want to disable fields like the `cancellation_type` field
  # from the `intermediate_example_ecommerce` view.

  join: users {
    from: basic_users
    }
  # This `from` parameter updates the view of the join from what is defined in the
  # `intermediate_example_ecommerce.explore` file. The advanced business scenario requires
  # us to replace the derived table approach that was used by the `intermediate_example_ecommerce`
  # Explore, so this `from` parameter updates the join's `from` clause back to the `basic_users` view.
  # The other join parameters, such as the `sql_on` parameter, are inherited from the join in the
  # `intermediate_example_ecommerce` Explore.

  join: user_summary_unfiltered {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id}=${user_summary_unfiltered.user_id} ;;
  }
  # To get the lifetime summary info, we are joining in the `user_summary_unfiltered` view,
  # which is a native derived table, and which uses the Explore's own logic to get user lifetime summaries.


  join: user_summary_filtered {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id}=${user_summary_filtered.user_id} ;;
  }
  # This join adds another native derived table, the `user_summary_filtered` view.
  # This derived table summarizes the filtered data by using `bind_all_filters` to
  # bind filters to the derived table.


  join: user_summary_and_order_items_fields {relationship: one_to_one sql: ;;}
  join: priority_item_filter_feature_support {relationship: one_to_one sql: ;;}
}
  # These are bare joined sourceless views. See the ADVANCED_LOOKML_README file for the explanation.

### The refinements below make adjustments to existing objects.
### See the ADVANCED_LOOKML_README.md document for more information on refinements.

# We don't want to surface the `intermediate_example_ecommerce` Explore itself, but we are including it here in order to extend it.
explore: +intermediate_example_ecommerce {
  hidden: yes}
# Set the `intermediate_example_ecommerce` Explore to hidden so it's not presented to end users.

# Simple updates to the `basic_users` view via refinement:
view: +basic_users {
  dimension: id {group_label: "System Keys" label:"User ID"}
  dimension: age_tier {
    type: tier tiers: [20,30,40,50,60,70] style: integer
    sql: ${age} ;;
  }
}
