<template lang="pug">
.camera
  .camera__container
    h1 Javascript Camera
    video#video(autoplay ref="video")
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
        width: { min: 1024, ideal: 1280, max: 1920 },
        height: { min: 576, ideal: 720, max: 1080 }
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
      this.itializeCamera();
    },
    stopVideoStream() {
      if (this.videoStream) {
        this.videoStream.getTracks().forEach((track) => {
          track.stop();
        });
      }
    },
    async initializeCamera() {
      const facingMode = this.useFrontCamera
        ? "user"
        : "environment";
      this.$set(this.constraints.video, 'facingMode', facingMode);
      try {
        this.videoStream = await navigator.mediaDevices.getUserMedia(this.constraints);
        this.$refs.video.srcObject = this.videoStream;
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