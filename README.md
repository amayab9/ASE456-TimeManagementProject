# Time Management Tool - Android
This command-line time management application is designed to help record and manage
your daily activities, track your time usage, and generate reports for better
time management. The application uses Dart and Firebase as the programming language and database.

## Business Logic
Jack reached out with a request to create a time management application with an Android/IOS UI interface that provides flexibility in recording and query time usage. Here are the key features:

### Recording Time
Users can navigate to the Record Page and input the following:
* Date
* From-time
* To-time
* Task
* Tag

### Query Data
Users can query data via a dropdown menu. The options to query by are:
* Today
* Date (yyyy-mm-dd)
* Task
* Tag

### Query Report
Users can generate a query report by navigating the report page. Users will enter:
* Start Date
* End Date

### Priority
Users can generate a priority list, or a most frequent activities report by navigating to the priority page.
Users click `Generate Report` to view their most frequent activities. 

## Database and Language
This application uses Dart and Flutter for the frontend, and Firebase Firestore as the backend database.

#### ASE456-TimeManagementProject
This application was developed as part of the ASE 420 course and the features are based on the provided requirements. As client communication was
not directed, the design adn features are crafted with the intention of providing a user-friendly experience. 
###### Code credit
* _formatTimestamp & _formatTime methods formed with help from ChatGPT to properly pull timestamps
