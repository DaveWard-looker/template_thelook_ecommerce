Intermediate LookML builds upon concepts in basic LookML, adding examples of typical enhancements that a modeler will use to meet specific business requirements and to make Explores more user friendly

PREREQUISITES: The intermediate level assumes familiarity with the basic concepts that are explained in the `1_basic_lookml` folder.

<h2><span style="color:#2d7eea">The intermediate example demonstrates:</span></h2>
 - How LookML views can be re-used in different Explores
 - Key Explore parameters and configurations
 - Enhancing Explores with additional field types (e.g. tiered fields) and UI control (e.g. labels)
 - The option to define Explores in their own files (see explanation below)

<h2><span style="color:#2d7eea">Example business context:</span></h2>
After experimenting with the basic Explore, a business user requested the following capabilities:
- Need to join additional information about the item that was sold (what was the item, brand, etc)
- General request that the Explore be more 'user friendly' (e.g. more intuitive labelling)
- User's first order date needs to be made available as an attribute of the user
- User need a separate Explore which will ONLY include order_items that are considered 'Valid'

<h2><span style="color:#2d7eea">What files to look at, and in what order?</span></h2>
1) **Model** - **Review the intermediate_ecomm.model file**. You will notice that most of the logic is defined elsewhere and brought into the model using [include](https://cloud.google.com/looker/docs/reference/param-model-include) statements.

2. **Explores** - See section below on <span style="color:#9862f0">Defining Explores in their own files</span>, then **review both .explore files side by side**. Notice:

- There are a few simple but important differences in Explore level paramaeters (e.g. to make 1 Explore 'Valid' orders only)
- Both Explores use the SAME view files. Object re-use is a core benefit of LookML and will help your logic be consistent across different contexts.

Here's an ER diagram of the code defined in the intermediate example ecommerce model file.
![intermediate_example_ecommerce.model LookML Diagram](https://cloud.google.com/looker/docs/images/sample_lookml_intermediate_erd.png)

3. **Views**

- **Review intermediate_order_items.view** for example derived fields of various [dimension types](https://cloud.google.com/looker/docs/reference/param-dimension-filter-parameter-types) and [measure types](https://cloud.google.com/looker/docs/reference/param-measure-types), basic drill paths with [drill_fields](https://cloud.google.com/looker/docs/reference/param-field-drill-fields), and label overrides for usability
- **Review intermediate_users.view** for an example of using a [derived table](https://cloud.google.com/looker/docs/reference/param-view-derived-table) (custom SQL statement) as the source of a view, for derived summary attributes. See [derived table documentation](https://cloud.google.com/looker/docs/derived-tables?hl=en) and [Dimensionalizing a Measure](https://cloud.google.com/looker/docs/best-practices/how-to-dimensionalize-a-measure) article for a fuller and more generic explanation.

4. **Open the [dashboard that uses the two Explores](/dashboards/2)**. Click "Explore from here" on different tiles and observe the Explore UI differences and generated sql differences between the two Explores.

**What's Next?** After you've checked out this 2_intermediate_lookml section, you can learn more advanced capabilities and techniques in the advanced section, starting with [ADVANCED LOOKML README](/projects/sample_thelook_ecommerce/files/3_advanced_lookml/ADVANCED_LOOKML_README.md)

---

<h3><span style="color:#9862f0">Defining Explores in their own files:</span></h3>
Explores are often defined directly within the model file, but it can be useful to define Explores in their own separate files.
You can then simply `include` the Explore file into a model file to manifest it there.
For clarity, it may be helpful to redeclare the Explore explicitly in the model file as well, as we've done here.
Defining Explores and objects in their own files can make it easier to find and manage the object, and provide flexibility to move or re-use objects between models.

---

<h1><span style="color:#2d7eea">Additional Resources</span></h1>

To learn more about LookML and how to develop visit:

- [Looker User Guide](https://looker.com/guide)
- [Looker Help Center](https://help.looker.com)
- [Looker University](https://training.looker.com/)
