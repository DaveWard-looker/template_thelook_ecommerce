<h2><span style="color:#2d7eea">The Development Workflow and Version Control</span></h2>

**Projects** contain the LookML files that model your data and configure the interface for end users. Your Looker instance may have multiple projects, where each one contains a set of related LookML files that are developed and version-controlled together.

To support a multi-developer environment, Looker is integrated with Git for version control. Follow the guide to [Setting up and testing a Git connection](https://docs.looker.com/r/develop/git-setup) to set up Git for your project. (You can go ahead and connect this sample project to your own repo just for fun!)

To edit LookML, expand the main menu (the three horizontal bars at the top left), choose the **Develop** section, and toggle on [Development Mode](https://docs.looker.com/r/terms/dev-mode) at the bottom of the panel. In Development Mode, changes you make to the LookML model exist only in your user account until you commit the changes and push them to production.

<h2><span style="color:#2d7eea">Navigating the Looker IDE</span></h2>
When viewing a LookML file, make use of the left and right side panels, as described next.

<h4><span style="color:#2d7eea">Left Panel:</span></h4>

- File Browser -- List of all files in the project in a hierarchical folder structure
- Object Browser -- Logical view of the LookML objects as opposed to a file-based view
- Find and Replace -- Find and/or replace specific text across the entire set of project files
- Git Actions -- View uncommitted changes, create a new branch, revert to production, etc.
- Settings -- Various project configurations and settings

<h4><span style="color:#2d7eea">Right Panel:</span></h4>

- Project Health (Checkbox near top right) -- Validate your LookML code
- Quick Help (i icon near top right, and select the Quick Help tab) -- Tells you what parameters are valid based on your cursor position and provides links to related documentation pages
