# Tide Pool Finder
Tide Pool Finder is an app designed to help users find great local sites to explore tide pools, take photos of what you find, and share those photos with others who are looking for great places to visit!

# Screenshots

The landing page currently offers four buttons.  Each implements a different Flutter package

![landing page screenshot](./images/screenshot_landing_page.png)

## Plan Trip

The Plan Trip button loads a Google Maps widget with markers indicating locations of Seattle-area tide pools.  Clicking a map marker reveals a bottom sheet with:
- the beach's name
- its address
- a link to open that address in the Google Maps app
- a link to that beach's public website.

![initial maps widget](./images/screenshot_plan_page.png)

![maps widget after clicking a marker](./images/screenshot_plan_page_2.png)

![Google Maps app after clicking the directions button in the Tidepool Finder app](./images/screenshot_plan_page_3.png)

## Add Photo

Add Photo enables the user to add photos to their Tide Pool Finder album on their device.  They can choose to either take a photo in the app, or import an existing photo from their gallery.  

## View Photos

Clicking View Photos opens a scrollable carousel displaying photos from their Tide Pool Finder album.

![photo carousel screenshot](./images/screenshot_carousel.png)

## Share Photos

In the Share Photos section, the user can upload photos to albums in their Google Photos account and share those albums with other users!

OAuth screen
![Oauth screen](./images/screenshot_oauth.png)

Login screen
![Login screen](./images/screenshot_login.png)

Connection to Google Photos
![Connecting to google photos](./images/screenshot_connect_photos.png)

Granting app permissions
![app permissions page](./images/screenshot_permissions.png)

Taking a photo
![taking a photo](./images/screenshot_camera.png)

Viewing shared albums from other users
![others' shared albums](./images/screenshot_view_albums.png)

Creating a new album to share
![create a new album](./images/screenshot_create_album.png)

Uploading photos to the new album
![upload photos to album](./images/screenshot_photo_upload.png)