<template lang="pug">
.camera
  .camera__container
    h1 Javascript Camera
    video#video(autoplay playsinline ref="video")
    .camera__wrapper.camera__wrapper--buttons
      button#btnPlay(@click="playHandler") play
      button#btnPause(@click="pauseHandler") pause
      button#btnScreenshot(@click="screenshotHandler") screen shot
      button#btnChangeCamera(@click="switchCameraHandler") change camera
    .camera__wrapper.camera__wrapper--photo
      h2 Screenshots
      #screenshots(ref="screenshots")
    .camera__wrapper.camera__wrapper--canvas
      canvas#canvas(ref="canvas")
</template>

<script>
export default {
  data() {
    return {
      useFrontCamera: true,
      videoStream: null,
      constraints: {
        video: {
          width: { min: 1024, ideal: 1280, max: 1920 },
          height: { min: 576, ideal: 720, max: 1080 }
        },
      },
    }
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
      this.$refs.screenshots.append(img);
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
      // const video = this.$refs.video;
      const videoTracks = stream.getVideoTracks();
      console.log('Got stream with constraints:', this.constraints);
      console.log(`Using video device: ${videoTracks[0].label}`);
      window.stream = stream; // make variable available to browser console
      this.$refs.video.srcObject = stream;
    },
    async initializeCamera() {
      this.constraints.video.facingMode = this.useFrontCamera
        ? "user"
        : "environment";
      try {
        this.videoStream = await navigator.mediaDevices.getUserMedia(this.constraints);
        this.handleSuccess(this.videoStream);
      } catch (err) {
        alert("Could not access the camera");
      }
    }
  },
  mounted() {
    this.initializeCamera();
  },
};
</script>

<style lang="scss" scoped>
.camera {

}
</style>