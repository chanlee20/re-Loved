
## When you check for the functionalities, 
When you post/edit/delete posts/accounts.. please update the tab by visiting the tab again. For example, after uploading the post, try going to other tab and come back for the updates in the items list. 


# ReLoved


reLoved is a second-hand, free-and-for-sale app made for the Washington University in St. Louis community. The app aims to create a safer and more sustainable way for students to buy and sell second-hand items within their community.


### Motivation
Many students often have unwanted items such as furniture, appliances, and clothing that they are looking to sell or give away before leaving campus. However, it can be difficult to find a trusted buyer or seller in the vast online marketplace. reLoved provides a secure platform for students to sell and purchase items within their own community, thus creating a safer and more convenient transaction process.

Additionally, reLoved promotes sustainability and upcycling by allowing students to find a new home for their gently used items instead of throwing them away.

### When Installing..
Use reLoved.xcworkspace file to launch the app. We all worked on M1, so it may not run properly on intel macs due to dependencies. If you experience any problems, please reach out to reloved.help@gmail.com to have testflight access.


### Scoring Categories

1. Novelty/Creativity of App Concept
- We believe that the app has interesting ideas of combining community interaction and upcycle. 

2. Technical Difficulty
- Our app required lots of calls to the backend to fetch data, which led to technical difficulty of the timing and size of fetching as well as implementing chatting feature, which we built from scratch to align with our design and functionality.

3. Complexity
- For a group size of 3, we have implemented considerable amount of features and made a fully functional full-stack app.

4. Utility
- We had a chance to converse with staff from residential life department and they said that they were looking for school inclusive marketplace platform to promote student market and safety. Our app fits that exactly and if we expand to web platform, we believe that we have a high chance of getting sponsored.


5. Error-Free
- The app is largely free from errors, including runtime errors. Though it shows some warnings, there are barely any warnings from the code, but the dependencies. Some pod file warnings popped up last minute, but didn't want to update it cause it may crash the app just before the submission.

6. Consistency
- Our app follows MVVM pattern. Each member clearly understands the pattern. Every file performs its task guidelined by its component's role. Our app exploits OOP, where we removed redundancy and viewModel communitcates by object. Our app also exploits functional programming where we have implemented numerous sub-functions that can be reused over the entire app's logic to remove redundancy and achieve simplicity.

7. User Experience
- We invited multiple users to join our testflight in order to garner reviews of our app before release. Thanks to those users, we updated our app to have features such as swipe back motion for easier navigation, reasonable error-handling cases when user does not have any inputs when submitting, and more.

8. User Interface
- We decided on our theme color as decribed below and made the UI consistent with those colors to make the app persistent. We limited our bottom bar with four sections so that the user doesn't feel overwhelmed with multiple buttons on the bottom edge of the app. We created an overlayed plus post button that the user can easily access to make a post. Our app utilizes as many icons as possible to make the UI more intuitive for the users to use.

9. Optimization 
- Our app is very responsive and well performant. It effectively retrieves data from the database in a timely manner, contingent upon a stable internet connection

10. iOS Feel
- Followed the human interface guidelines (https://developer.apple.com/accessibility/) from Apple to utilize as many iOS inputs and components as possible, follow UI patterns, implement fundamental foundations design elements, and more.

11. Accessibility
- Given that there are a lot of students at WashU who have color blindness, we decided to choose our main theme color from the color blind friendly palette (https://venngage.com/blog/color-blind-friendly-palette/). 

12. Testing 
- The code has decent coverage of testing. We followed the instructions given in the class to write with a high level of code coverage.

13. Framework Usage
- We utilized the SwiftUI framework and Firebase to enhance its functionality. SwiftUI provides a modern and intuitive way to build the user interface while Firebase is utilized for its authentication, database, and storage features. Together, these frameworks allow us to create a seamless and secure user experience for our app users.

14. Swifty Code
- We tried to keep the code very 'swifty' by naming our variables in CamelCase for classes, structs, and enums and lowercase camelCase for variables and functions. We did not use semicolons, line break before opening brace {, paranthesis aroung if-statement condition, and always had space around operators (except unary operators). If used line breaks if lines were too long. We also made our naming convention very clear so that if corresponds to grammatical English phrases. 

15. Modern iOS Feature
- Got a review that a gesture motion to easily navigate through the screens would be nice from a testflight user. Thus, we decided to implement swipe motion that allows users to conveniently swipe through the navigation stack in a modern manner.



----

### Features

#### Account Management
- Create, edit, and delete account profiles
- ((Verify email addresses to ensure user authenticity  -> WashU email blocked all the emails from Firebase so we had to take it down))

#### Item Management
- Upload, edit, and delete items for sale or giveaway
- Categorize items based on their intended use or category
- Search for items based on category and keyword
- View a list of items available for sale or giveaway
- Like and store items in a 'Liked' tab for future reference
- Keep track of items that are on sale or have already been sold
- Keep track of items that are posted by the user

#### Communication
- Message other users within the app to arrange transactions
- Send images in the chat for better chatting experience
- Archive chat logs for future reference
- Rate other users after a successful transaction
- Block or report other users if necessary

#### Additional Features
- Search history to easily find previously viewed items
- Pull-up post feature to re-list previously sold items

-----

### Contributors
Chae Hun Lim  chaelim@wustl.edu <br>
Chan Lee  chan.l1@wustl.edu <br>
Jiwoo Seo   jiwooseo@wustl.edu 

### Color hex codes:
#5F879D
#F3EEE2
#29556D
#B6D3E4
#CBC2AD
