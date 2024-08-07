include: "/3_advanced_lookml/user_summary_unfiltered.view.lkml"

# An additional extended view used to compare unfiltered totals to filtered totals of the same users
view: user_summary_filtered {
  extends: [user_summary_unfiltered]
  derived_table: {
    explore_source: advanced_example_ecommerce {
      bind_all_filters: yes
    }
  }
  dimension: label_placeholder {sql:(Filtered Summary);;}
}
