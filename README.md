# All-Bout Meme
This is my project Submission as part of a Udacity iOS Developer Nano Degree program.

## A custom Meme Generating App.

![SampleMeme](https://cloud.githubusercontent.com/assets/22570141/22391676/816265f6-e4a7-11e6-8508-ef883cca34f6.JPG)


## The All-Bout Meme Editor
The Meme editor allows a user to select an image from either the photo album or from the onboard camera. The user can then edit
the meme by selecting the text fields and entering a message with the keyboard.

![MemeEditor](https://cloud.githubusercontent.com/assets/22570141/22391675/81611bec-e4a7-11e6-83cf-31f81e6c7a84.PNG)


## Keyboard Movement
The main View's behavior has been altered to move upwards with the apearance of the keyboard so that the user always has
a good point of view on the meme that they are editing.

![KeyBoardMoves](https://cloud.githubusercontent.com/assets/22570141/22391679/8163c5fe-e4a7-11e6-99f7-7acfb9a30516.PNG)


## Meme Styles to choose from
The user also has the option to deviate from the default meme font by selecting the Styles button on the bottom. This brings
up the Font menue (a TableView) which displays all the available fonts and a sample of what they look like.

![FontMenu](https://cloud.githubusercontent.com/assets/22570141/22391680/8164a2e4-e4a7-11e6-806d-d39fbdc3f0bf.PNG)


## Share your clever memes with your friends
Once a meme is completed the user can select the share button in order to bring up an activity controller that gives them the
option of sending it through a text message, Facebook, Twitter, or simply save it to the photo album.

![SocialSharing](https://cloud.githubusercontent.com/assets/22570141/22391678/8162d2a2-e4a7-11e6-86a3-c888b04be543.PNG)

## View a collection of all your sent memes
After the meme has been share with friends or saved to the photo album, the user can look over the memes that they've sent in
either a list view or as tile view.

![ListView](https://cloud.githubusercontent.com/assets/22570141/22391677/81628c20-e4a7-11e6-8335-31bec0b52dde.PNG)

![CollectionView](https://cloud.githubusercontent.com/assets/22570141/22391681/8178d4a8-e4a7-11e6-8dfc-164e9e4e1e65.PNG)


### Further ideas to be done in the future
- Completed: Add data persistence for Sent Memes
- Completed: Add the ability to remove memes from the persistant data model
- Possibly add the ability to edit already sent memes and be able to resend new meme.

This app now impliments (as of 5/9/2017) basic Data Persistence using the Core Data frmaework. Sent Memes are saved on the local disc and retrieved using NSFecthRequests. A delete method has also been added that uses an NSPredicate to search for the Meme to delete (using it's unique identifier') in the Data Base.
