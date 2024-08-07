Advanced LookML builds upon concepts in Intermediate LookML, introducing parameterization for enhanced UI functionality, and advanced logic reuse, which allows you to build modular and reusable code.

<h1><span style="color:#2d7eea">The advanced LookML demonstrates:</span></h1>
*(see corresponding sections below for related guidance)*

- **Inheritance / Logic Re-use with Extends and Refinements** - Re-use an existing LookML objects (views or Explores) and either adjust their behavior ([refinement](https://cloud.google.com/looker/docs/lookml-refinements)) or use them as a template for a new object ([extend](https://cloud.google.com/looker/docs/reusing-code-with-extends))
- Achieve **advanced customization** such as special filter behavior using [liquid](https://cloud.google.com/looker/docs/liquid-variable-reference), [html](https://cloud.google.com/looker/docs/reference/param-field-html), [paramters](https://cloud.google.com/looker/docs/reference/param-field-parameter), and [links](https://cloud.google.com/looker/docs/reference/param-field-link)
- Use a **[Native Derived Table](https://cloud.google.com/looker/docs/creating-ndts)** for advanced re-using Explore logic when defining a [derived tables](https://cloud.google.com/looker/docs/derived-tables)
- **[Persisting](https://cloud.google.com/looker/docs/derived-tables?hl=en#persistent_derived_table) derived tables, using [datagroups](https://cloud.google.com/looker/docs/caching-and-datagroups#caching_queries_and_rebuilding_pdts_with_datagroups)** to control the build frequency.
- **'Bare-joined source-less views'** approach to keeping views modular and indpendent
- Define **[aggregate tables](https://cloud.google.com/looker/docs/reference/param-explore-aggregate-table)** to create small efficient physicalized tables to support frequent types of queries
- Define [data tests](https://cloud.google.com/looker/docs/reference/param-model-test) to validate the logic of your model

<h1><span style="color:#2d7eea">Business context</span></h1>
- Manage how data is exposed to users. The full example_ecommerce Explore needs to be accessible to only special users, and all other users only see orders with a "Valid" status
- Support multiple drill paths with Links declaration
- Provide additional user summary information such as lifetime revenue rank
  - The user summary information should follow our Explore's business logic, for example Lifetime Revenue Rank needs to be looking at valid only
- Provide a 'High Value Items Only' toggle, which depends on the above user summary information
- Ensure data quality. Run data tests that will be triggered in Looker with expected results
- Make the LookML more reusable and modular

Here's an ER diagram of the code defined in the advanced example ecommerce model file.
![advance_example_ecommercce.model LookML Diagram](https://cloud.google.com/looker/docs/images/sample_lookml_advanced_erd.png)

---

<h1><span style="color:#2d7eea">Concepts</span></h1>

<h3><span>Inheritance / Logic Re-use with Extends and Refinements</span></h3>
<h4><span>Extends</span></h4>
You can either [extend an Explore](https://cloud.google.com/looker/docs/reference/param-explore-extends) or [extend a view](https://cloud.google.com/looker/docs/reference/param-view-extends), to create a new object based on an existing object.

By using extensions, you can ensure consistency between related objects, and keep your code modular.

We demonstrate extensions in the Explore called [advanced_example_ecommerce](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/advanced_example_ecommerce.explore.lkml) and view called [advanced_order_items](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/advanced_order_items.view.lkml).

_CONCEPT NOTE: Why did we use extension in the advanced_order_items Explore?_

- Because of the business requirement of only allowing special users to view all orders, and all other users to see only "Valid" orders.
- With Extension, we were able to leave the original objects intact and creating the newly requested object, and ensure they stay in sync.
- In this case, we extend the original Explore and add a `sql_always_where filter` to the extended Explore.

Adjustments made in the extending object will add to and/or override the LookML from the object being extended!

<h3><span>Advanced Customization using parameters, liquid, and HTML</span></h3>
[Liquid](https://cloud.google.com/looker/docs/liquid-variable-reference) is a templating language that you can use in Looker to create more dynamic content.
Here is the list of files that include liquid:
- [advanced_order_items.view](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/advanced_order_items.view.lkml): total_sale_price dimension
- [priority_item_filter_feature_support.view](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/priority_item_filter_feature_support.view.lkml)
- [user_summary_and_order_items_fields.view](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/user_summary_and_order_items_fields.view.lkml)
- [user_summary_unfiltered.view](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/user_summary_unfiltered.view.lkml): user_revenue_rank_group dimension

<h4><span>Drill Fields</span></h4>
[Drill Fields](https://cloud.google.com/looker/docs/reference/param-field-drill-fields) control what happens when a user clicks on the value of a table cell while they're exploring data. You can define a list of fields that you want to show in a drill view.

Once users click a drill field, they are taken into a drill view. Fields and filters will be populated in the drill view based on row that user selects.

Drilling is very powerful, allowing you to slice and dice and dive deeper into your data!

<h3><span>Native Derived Tables</span></h3>
The [user_summary_unfiltered.view](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/user_summary_unfiltered.view.lkml) file demonstrates a [Native Derived Table](https://cloud.google.com/looker/docs/creating-ndts).

Original SQL Derived Table

- The following SQL query is an example of a SQL derived table
- This is similar to what the Native Derived Table generates

  ```
   sql:
   SELECT
       user_id
       , COUNT(DISTINCT order_id) AS lifetime_orders
       , SUM(sale_price) AS lifetime_revenue
       , CAST(MIN(created_at)  AS TIMESTAMP) AS first_order
       , CAST(MAX(created_at)  AS TIMESTAMP)  AS latest_order
       , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created_at))
         AS number_of_distinct_months_with_orders
     FROM bigquery-public-data.thelook_ecommerce.order_items
     GROUP BY user_id
   ;;
  ```

Reasons to use native derived table:

1. Reuse LookML dimensions and measures that you have already defined.
2. You have access to use powerful LookML parameters and filters on top of the derived table.

- We want to take advantage of [bind_all_filters](https://cloud.google.com/looker/docs/reference/param-view-explore-source#passing_filters_into_a_native_derived_table) so that the totals here reflect filters in the main query.
- This is one reason why you would use a native derived table over SQL derived table.

<h3><span>Persisting Derived Tables and Using Datagroups</span></h3>
Use [datagroup](https://cloud.google.com/looker/docs/reference/param-model-datagroup) to assign a caching policy for Explores and/or to specify a persistence strategy for persistent derived tables (PDTs).

We have created a seperate LookML file to declare our datagroup inside the [etl_datagroup.datagroup.lkml](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/etl_datagroup.datagroup.lkml) file.

<h3><span>'Bare-joined source-less views'</span></h3>
Bare joins are good for parameterized fields and cross view references, to keep base views independent.
A common technique is to use a base view/explore that is tightly aligned to the underlying physical table and add other fields and configurations (or in particular niche or experimental fields) in an extension of that base.
This allows separation of code from base table structure or join, from customized, enhanced features.
In this project, we housed our [special parameterized filter support fields](/3_advanced_lookml/priority_item_filter_feature_support.view.lkml) and our [fields that use multiple views](/3_advanced_lookml/user_summary_and_order_items_fields.view.lkml) in bare-joined sourceless views.

```
join: user_summary_and_order_items_fields {
  # No actual join is occurring and so we use one_to_one
  # to avoid triggering symmetric aggregates unnecessarily
  relationship: one_to_one
  # Whitespace sql (not sql_on!) so no join clause appears in the final SQL
  sql:  ;;
}
```

<h3><span>Aggregate Tables</span></h3>

[Aggregate tables](https://cloud.google.com/looker/docs/reference/param-explore-aggregate-table) are used by Lookers' [Aggregate Awareness Feature](https://cloud.google.com/looker/docs/aggregate_awareness) and can be used to minimize the number of queries required for the large tables in your database.
In the [agg_table_file.lkml](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/agg_table_file.lkml) file, there is a simple aggregate table declared for the order items table.

<h3><span>Data Tests</span></h3>
On top of the LookML Validator and Content Validator, Looker [Data Test](https://cloud.google.com/looker/docs/reference/param-model-test) allow you to validate the logic of your LookML model.
In the [data_test_file.lkml](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/data_test_file.lkml) file, there are three data tests.

1. Ensure order ID primary key is unique
2. Check if order validation status is "Valid"
3. Check whether data load has completed within last two days

To run the data tests, click on "Project Health" on the top right corner of the IDE and in the last section, under Data tests, click on "Run Data Tests".

<h1><span style="color:#2d7eea">What's Next?</span></h1>
- If you haven't already, review the LookML files in this 3_advanced_lookml folder, to see examples in action
- View the [Advanced Ecommerce Dashboard](/dashboards/3) built using concepts listed in this README.
- Try editing different parameters on fields, views, and Explores, and observe their impact on the dashboards and particularly the corresponding Explores
- Challenge: Try creating your own LookML objects on this dataset, such as a simple Explore that only has the Users view.
- [Connect your own database or dataset](https://cloud.google.com/looker/docs/connecting-to-your-db), and begin creating LookML Explores that will help you and your organization get the most out your data!

---

<h1><span style="color:#2d7eea">Additional Resources</span></h1>

To learn more about LookML and how to develop visit:

- [Looker User Guide](https://looker.com/guide)
- [Looker Help Center](https://help.looker.com)
- [Looker University](https://training.looker.com/)
