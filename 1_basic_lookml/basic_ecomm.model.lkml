### Basic ecomm model file ###
# This is a simple example model file.
# For detailed information, see the BASIC_MODEL_COMPANION_README.md markdown file in this folder.
# Open a separate browser window with the BASIC_MODEL_COMPANION_README.md document to view both documents side by side.
#
# For a fundamental overview of model files and other LookML objects, start with the BASIC_LOOKML_README.md file.
###

connection: "sample_bigquery_connection"

label: "Z) Sample LookML" # Set UI label to "Z)..." so this demo project's Explores appear last in the Explore list

include: "/1_basic_lookml/*.view.lkml" # The * wildcard was used here to include all view files in this folder

### OUR FIRST EXPLORE IS DEFINED BELOW ###
# REFRESHER: What is an Explore? Please see the BASIC_MODEL_COMPANION_README.md markdown file.
#
# ## BUSINESS CASE USED IN THIS EXAMPLE
# # We have a table of transactional order_items sales records including a user_id, and a table of user information.
# # Our analysts want to create queries and visualizations about sales, including info about the user who created the order.
####

explore: basic_order_items {
  label: "1) Basic Ecommerce" # Set the Explore's UI label to clarify it and distinguish it from our other Explores.
  join: basic_users { # Bring in user data for the user who created the order item
    type: left_outer # A standard SQL left join will be used (the method keeps all records, even if no joinable user data is found)
    relationship: many_to_one # The "left side" table (the table we're joining from, the basic_order_items table) can have many records for one record in the "right side" table (the basic_users table)
    sql_on: ${basic_users.id} = ${basic_order_items.user_id} ;; #  This uses the LookML references ( ${} syntax ) to define the on clause of the join that Looker will write (when needed)
  }
}
