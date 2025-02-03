# Fake Text Story Video Generator 🎬

This is a video creation tool that you can generate fake iMessage styled text story videos with text-to-speech, sound effects, and customizable backgrounds.
I'm pretty sure you came across those videos on tiktok and youtube shorts where two AI voice actors read out a fake text message conversation. This type of videos are fun and fairly engaging, but to make them either you need to pay for AI tools or edit videos yourself on tools like capcut, which costs money and very time consuming. That's why I created this website, to simply create fake text interface and render it into a video with voiceovers, background videos and sound effects. This tool will be helpful for those who looking for video automation tool for tiktok and youtube shorts. Try now and create your own viral shorts today. NO EDITING REQUIRED, PURE PROGRAMMING MAGIC 🧙

I deployed this python app on Google Cloud Run, which is abit slow but works completely fine.
Try it out [here](https://my-service-662964498291.us-central1.run.app) and Go Viral today! 🚀

## Features 🌟

- 💬 Create realistic iMessage conversations - you can send both texts and images
- 🔄 Switch between sender and receiver messages
- ✏️ Edit, delete, or add messages above or below
- 🔊 Add sound effects to messages (Vine boom, notification, rizz, iMessage text sound)
- 🎭 Choose from multiple voice actors using ElevenLabs API
- 🎬 Select from various background video styles
- 👤 Customize profile image and name
- 🌓 Choose from two themes - light and dark
- 📥 Download as MP4 video

## Libraries and tools 🛠️
- [Selenium](https://www.selenium.dev/) for scraping the chat interface
- [ElevenLabs](https://elevenlabs.io/) for realistic tts voice over
- [Google Cloud Run](https://cloud.google.com/run) for hosting the app
- [cloudinary](https://cloudinary.com/) for storing and serving background videos

## Setup (if you want to run it locally) ⚙️

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Run the Flask application:
```bash
python app.py
```

3. Open your browser and navigate to:
```
http://127.0.0.1:8080
```

## Usage 📝

1. Enter your ElevenLabs API key.
2. Customize the chat interface:
   - Click profile image to upload a custom photo
   - Click the name to edit it
   - Select voice actors for sender and receiver
   - Choose your preferred background style

3. Create messages:
   - Type your message in the input field
   - Use the ⇄ button to toggle between sender/receiver
   - Use camera icon to upload image
   - Press Enter or click Send to add message

4. Edit messages:
   - Click any message to:
     - Edit text
     - Switch sender/receiver
     - Add message above/below
     - Add sound effects
     - Delete message
     - Swap images

5. Generate Video:
   - Click "Generate Video" button
   - Wait for processing
   - Video will download automatically to your downloads folder