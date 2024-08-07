### Example Data Tests File (with 3 tests)
# Remember to include data tests in any model file where you want to run your data tests

### ABOUT TESTs
# The `test` parameter lets you validate the logic of your model
# Use them to make sure your in-flight code changes didn't break any assumptions or fundamentals about your Explore
#
# For each data test, you create a query and a yesno assertion statement
# Then run your data tests (from Project Health section of the panel at right)...
#  to test that the assertion is true for each row of the test query
# If the assertion statement returns yes for every row of the test query, the data test passes
#
# Link to documentation : https://cloud.google.com/looker/docs/reference/param-model-test


# Data test to ensure primary key is unique
test: order_id_is_unique {
  explore_source: advanced_example_ecommerce {
    column: id {field: order_items.id}
    column: count {field: order_items.count}
    sorts: [order_items.count: desc]
    limit: 1
  }
  assert: order_id_is_unique {
    expression: ${order_items.count} = 1 ;;
  }
  }

# Data test to check if validation status is "Valid"
test: status_is_valid {
  explore_source: advanced_example_ecommerce {
    column: validation_status {field: order_items.validation_status}
  }
  assert: status_is_valid {
    expression: ${order_items.validation_status} = "Valid" ;;
  }
}

# Data test to check whether data load has completed within last two days
test: data_is_recent {
  explore_source: advanced_example_ecommerce {
    column: validation_status {field: order_items.created_at_date}
    sorts: [order_items.created_at_date: desc]
    limit: 1
  }
  assert: data_is_recent {
    expression: diff_days(now(), ${order_items.created_at_date}) < 2 ;;
  }
}