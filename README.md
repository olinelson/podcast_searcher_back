This project has a frontend repo located here: https://github.com/olinelson/podcast_searcher_front

## What is this?
This app creates clickable transcripts of words spoken in audio and video files using the Google speech-to-text API. Users can upload any format of Video file, Audio file or simply paste in a youtube video link.

## Getting Started
In Order to get this backend API up and running you must have a .env file (git-ignored) that contains a variety of API keys for Google Cloud, Cloud Convert, JWT and Office 365 account. An Example is provided below:

```
JWT_KEY=your_chosen_jot_key

GOOGLE_APPLICATION_CREDENTIALS={your_google_appliction_json_goes_here}


CLOUD_CONVERT_KEY=your_cloud_convertkey

# Google Application Credentilas are repeated below, but seperated into individual variables.
# This is for use with the Cloud Convert Api.


TYPE=

PROJECT_ID=

PRIVATE_KEY_ID=

PRIVATE_KEY=

CLIENT_EMAIL=

CLIENT_ID=

AUTH_URI=

TOKEN_URI=

AUTH_PROVIDER=

CLIENT_CERT=


OFFICE_USERNAME=

OFFICE_PASSWORD=
```

When running google cloud operations in the development environment it is required that you have a local copy of the google_application_credentials.json file and run the following command in the terminal:

```
export GOOGLE_APPLICATION_CREDENTIALS="config/secrets/your_credential_file.json"
```

Note that this must be repeated every time you open a new terminal session.
