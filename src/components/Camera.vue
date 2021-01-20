<template lang="pug">
.camera
  .camera__container
    h1 Javascript Camera
    video.camera__video(autoplay playsinline ref="video")
    .camera__wrapper.camera__wrapper--buttons
      button#btnPlay(@click="playHandler") play
      button#btnPause(@click="pauseHandler") pause
      button#btnScreenshot(@click="screenshotHandler") screen shot
      button#btnChangeCamera(@click="switchCameraHandler") change camera
    .camera__wrapper.camera__wrapper--photo
      h2 Screenshots
      .test(v-for="img in snapshots")
        img(:src="img.src")
    .camera__wrapper.camera__wrapper--canvas
      canvas#canvas(ref="canvas")
</template>

<script>
import * as faceapi from 'face-api.js';

export default {
  data() {
    return {
      useFrontCamera: true,
      videoStream: null,
      snapshots: [],
      constraints: {
        video: {
          width: { min: 1024, ideal: 1280, max: 1920 },
          height: { min: 576, ideal: 720, max: 1080 },
        },
      },
    };
  },
  methods: {
    playHandler() {
      this.$refs.video.play();
    },
    pauseHandler() {
      this.$refs.video.pause();
    },
    screenshotHandler() {
      const img = document.createElement("img");
      this.$refs.canvas.width = this.$refs.video.videoWidth;
      this.$refs.canvas.height = this.$refs.video.videoHeight;
      this.$refs.canvas.getContext("2d").drawImage(this.$refs.video, 0, 0);
      img.src = this.$refs.canvas.toDataURL("image/png");
      this.snapshots.push(img);
    },
    switchCameraHandler() {
      this.useFrontCamera = !this.useFrontCamera;
      this.initializeCamera();
    },
    stopVideoStream() {
      if (this.videoStream) {
        this.videoStream.getTracks().forEach((track) => {
          track.stop();
        });
      }
    },
    handleSuccess(stream) {
      this.$nextTick(() => {
        const video = this.$refs.video;
        const videoTracks = stream.getVideoTracks();
        console.log("Got stream with constraints:", this.constraints);
        console.log(`Using video device: ${videoTracks[0].label}`);
        window.stream = stream; // make variable available to browser console
        this.$refs.video.srcObject = stream;
        video.addEventListener('play', () => {
          console.log('playing...');
          const canvas = this.$refs.canvas;
          const ctx = canvas.getContext('2d');
          // const canvas = faceapi.createCanvasFromMedia(video);
          // document.body.append(canvas)
          const displaySize = { width: video.clientWidth, height: video.clientHeight }
          faceapi.matchDimensions(canvas, displaySize)
          setInterval(async () => {
            ctx.drawImage(video, 0, 0);
            const detections = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks().withFaceExpressions()
            const resizedDetections = faceapi.resizeResults(detections, displaySize)
            // canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height)
            faceapi.draw.drawDetections(canvas, resizedDetections)
            faceapi.draw.drawFaceLandmarks(canvas, resizedDetections)
            faceapi.draw.drawFaceExpressions(canvas, resizedDetections)
          }, 100)
        });
      });
    },
    async initializeCamera() {
      this.constraints.video.facingMode = this.useFrontCamera
        ? "user"
        : "environment";
      try {
        this.videoStream = await navigator.mediaDevices.getUserMedia(
          this.constraints
        );
        this.handleSuccess(this.videoStream);
      } catch (err) {
        alert("Could not access the camera");
      }
    },
  },
  async mounted() {
    await Promise.all([
      faceapi.nets.tinyFaceDetector.loadFromUri('./models'),
      faceapi.nets.faceLandmark68Net.loadFromUri('./models'),
      faceapi.nets.faceRecognitionNet.loadFromUri('./models'),
      faceapi.nets.faceExpressionNet.loadFromUri('./models')
    ]);

    this.initializeCamera();
  },
};
</script>

<style lang="scss" scoped>
.camera {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  &__video {
  }

  &__wrapper {
    &--canvas {
      // display: none;
    }
    &--buttons {
      display: flex;
      align-items: center;
      justify-content: space-around;
      button {
        padding: 1px 2px;
      }
    }
  }
}
</style>
