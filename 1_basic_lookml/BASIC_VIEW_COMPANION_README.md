<span style="background-color:aliceblue">
**You Are Here**: You are reading the README that explains foundational concepts about view files. It is intended to be viewed alongside the [basic_order_items.view file](/projects/sample_thelook_ecommerce/files/1_basic_lookml/basic_order_items.view.lkml).
<br><br>For an overview of the whole sample project, head back to [START_HERE_README](/projects/sample_thelook_ecommerce/files/0_start_here/START_HERE_README.md).
</span>

<h1><span style="color:#2d7eea">View File Guide</span></h1>

This document explains the basics of a **View file** and will walk you through the [basic_order_items.view file](/projects/sample_thelook_ecommerce/files/1_basic_lookml/basic_order_items.view.lkml).
It is a good idea to open this README and the view file (linked above) in separate tabs.

<h2><span style="color:#2d7eea">What Is a View File?</span></h2>
- A **view file** in Looker describes the field logic correlated to of one of the tables in your database and tells Looker how to write SQL to query for those fields.
- Like a SQL query, view files can be used to apply transformations to fields in the SELECT clause (like a case when statement, for example).
- View files can also be used to describe aggregation functions like SUMs, AVGs, COUNTs, etc. on fields. We will see some examples of these below.

Let's break down the first few lines of the [basic_order_items.view file](/projects/sample_thelook_ecommerce/files/1_basic_lookml/basic_order_items.view.lkml).

- When you first [create a view file from an existing table](https://www.youtube.com/watch?v=cXQaBWVM7WI&t=94s), Looker auto-generates much of the code that you will need (this example is 90% auto-generated).
- This view file represents the `order_items` table, where each row represents a unique ecommerce order item (unique by the ID) placed by a user.

1.  `view:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-view-view?version=23.6&lookml=new)
    - Creates a view file for us with a name, which can be anything we like but is typically the same name as the table correlated in sql_table_name.
2.  `sql_table_name:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-view-sql-table-name?version=23.6&lookml=new).
    - The name of the table this view is based on, written exactly as you would write it in a SQL query.
    - Think of this as the source data of this view file; without it this view file isn't correlated to any table in your database.
    - The SQL here will be used in the FROM or JOIN clause when someone selects a field from this view in Looker's front end.

The next thing we see in our view file is a dimension object. Let's talk about that!

<h2><span style="color:#2d7eea">What Is a Dimension?</span></h2>

- A **dimension** is a field used for slicing or grouping (used in the GROUP BY in SQL), or in bar chart it is the field that typically goes on the x axis.
- Each dimension you see in this file will become a selectable item in an Explore in Looker and will trigger some SQL to be written.
- It is not an aggregation nor something you would typically plot on the y axis of chart
- If you find yourself wanting to plot a dimension on the y axis -- you should create a **measure**. More on that later...

Now let's look at the dimension parameters:

1.  `dimension:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-dimension?version=23.6&lookml=new)
    - Creates a dimension with a specific name, which can be anything we like, but is typically the same name as the column in the DB
2.  `primary_key:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-primary-key?version=23.6&lookml=new)
    - Specifies this is the primary key of the table, defined as the column that has a unique value for every row in this table
    - This paramater should only be used on one dimension per view file, as there should only be one primary key per table
    - If you want to deep dive on why this is important, read about [the fannout problem and how Looker solves it with symmetric aggregations](https://cloud.google.com/looker/docs/best-practices/understanding-symmetric-aggregates)
3.  `type:`[(official doc)](https://cloud.google.com/looker/docs/reference/param-dimension-filter-parameter-types?version=23.6&lookml=new)
    - Tells looker the type of data the field contains (like string, number, date, etc)
    - This affects how Looker renders the field in the front end and some other UX items like suggestions and filter UI, so it is important to get this correct
4.  `sql:`[(official doc)](https://cloud.google.com/looker/docs/reference/param-field-sql?version=23.6&lookml=new)
    - The actual SQL looker will put in the SELECT clause when a user clicks on this dimension in the UI.
    - You can use any SQL here that your database supports.
    - Something that is not native SQL here is the `${}` notation used in `${TABLE}`. Let's talk about that!
5.  `${}` substitution operator notation [(official doc)](https://cloud.google.com/looker/docs/sql-and-referring-to-lookml#substitution_operator_)
    - This is a looker subsitution operator that allows you to reference another lookML object without manually writing the same SQL.
    - In our example it is used for `${TABLE}`, a special reference that pulls the table name from the view's `sql_table_name` parameter
    - This saves you from having the write the same SQL over again, also makes it easier if a table name ever changes as we'd only need to update the sql line of the `sql_table_name` and not every dimension
    - We can also use ${} syntax to reference other Looker dimensions or measures, we will see an example of that later

We can also create our own custom dimensions with any SQL logic we like, like this example:

```
dimension: is_returned_or_cancelled {
type: string
sql: CASE
        WHEN ${status} IN ('Returned', 'Cancelled') THEN 'Returned or Cancelled'
          ELSE 'In progress or Completed'
        END;;
}
```

- This example doesn't introduce any new parameters, but shows us using a CASE WHEN statement in the `sql` of this custom dimension
- Remember you can use any SQL your database dialect supports here, so you can do anything you'd typically do in a SELECT clause
- Notice the substitution operator `${}` used to call the `${status}` dimension. This will inject whatever is in the `sql` parameter of our `status` dimension into the `sql` here
- You will learn there are multiple ways to accomplish tasks in LookML. For example we could have used to `case` [(official doc)]() LookML parameter to accomplish this, but I chose to write SQL this time instead.

We can see Looker auto-creates a dimension for every column in our table until we see something new called a **dimension_group**. Let's talk about those:

<h2><span style="color:#2d7eea">What Is a Dimension Group?</span></h2>

- **Dimension groups** are similar to dimensions, but create a group of selectable fields in the front end instead of just one.
- These are most common for date/time fields, where off of one database column a user may want to slice by a number of different things (time, day, week, month, quarter, year, etc.)
- When [creating a view file from an existing table](https://www.youtube.com/watch?v=cXQaBWVM7WI&t=94s), Looker will typically auto create dimension groups for every date/time field in that table

Let's break down the dimension groups we see in our sample view file:

1.  `dimension_group:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-dimension-group?version=23.6&lookml=new)
    - Creates a dimension group with a specific name, which can be anything we like, but is typically the same name as the column in the DB
2.  `timeframes:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-dimension-group?version=23.6&lookml=new#timeframes)
    - Specifies the list of different selectable timeframes to expose to the user for a dimension group of `type: time`
    - This is most common for a date field, where a off a date column in the database the user may want to group by day,week, month, year etc.

The last things we see in our view file are measures. Let's talk about those.

<h2><span style="color:#2d7eea">What is a Measure?</span></h2>

- A **measure** is a field that performs some sort of aggregation, like a sum, count, average, min, max, etc.
- A measure is what would be plotted on the y axis of a typical bar chart,and in SQL it would not go in the group by clause
- Each measure you see in this file will become a selectable orange item in the front end of Looker and will trigger some SQL to be written
- Looker auto generates a count of all rows (aka `COUNT(*)`) measure, but just like dimensions we can and should create our own custom measures
- It is a best practice to create measures for each KPI your business users will want to use in visualizations

Let's break down the measures in our view file:

1.  `measure:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-measure?version=23.6&lookml=new)
    - Creates a measure with a specific name, which can be anything we like
2.  `label:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-label?version=23.6&lookml=new)
    - Optional - gives this measure a different label to be shown in the front end of Looker
3.  `type:`[(official doc)](https://cloud.google.com/looker/docs/reference/param-measure-types?version=23.6&lookml=new)
    - Tells looker the type of aggreagation for this field (like sum, average, count, count_distinct, etc)
    - We can also use `type: number` if we prefer to write the aggregation SQL ourselves or need to reference existing aggregations
4.  `sql:`[(official doc)](https://cloud.google.com/looker/docs/reference/param-field-sql?version=23.6&lookml=new)
    - The actual SQL to aggregate
    - For most measure types, Looker will wrap whatever is inside this `sql:` parameter in the corresponsing aggregation function (ex: `type: sum` will wrap whatever is inside the `sql` inside of a `SUM()` function)
    - Conversely, there are less-frequently used measures types (e.g. `type:number`,`type:string`) where this `sql:` block is exactly the SQL Looker will use when this measure is clicked on in the front end.
    - Notice the use of the substitution operators `${}` notation used in `${sale_price}`, this will pull the `sql` from the `sale_price` dimension into this `sql` parameter
5.  `value_format_name:` [(official doc)](https://cloud.google.com/looker/docs/reference/param-field-value-format-name?version=23.6&lookml=new)
    - Optional - assigns a value format(like rounding, percent symbols, $, etc.) to the rendering of this field in the front end
