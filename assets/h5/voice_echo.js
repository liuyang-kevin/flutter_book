
if (typeof (Meyda) == undefined) {
    console.log("Meyda loaded");
} else {
    console.log("Meyda loading");
    var js = document.createElement("script");

    js.src = "assets/h5/assets/js/dependencies/meyda/meyda.min.js";

    document.body.appendChild(js);
    js.onload = ()=>{
        console.log(Meyda);
    }
}

var audio;
var mediaConstraints = {
    audio: {
        echoCancellation: { exact: true },
        googEchoCancellation: { exact: true },
        googAutoGainControl: { exact: true },
        googNoiseSuppression: { exact: true },
    }
}

// var Mayda = "";

window.stopVoiceEcho = () => {
    if (audio) {
        audio.srcObject.getTracks().forEach(function (track) {
            if (track.readyState == 'live' && track.kind === 'audio') {
                track.stop();
            }
        });
        audio = null;
    }
}

window.startVoiceEcho = () => {
    stopVoiceEcho();
    navigator.mediaDevices.getUserMedia(mediaConstraints)
        .then(stream => {
            audio = new Audio();
            audio.srcObject = stream;
            audio.play();
        })
        .catch(e => console.log(e));
}

window.VoiceEcho = class {
    DEFAULT_MFCC_VALUE = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    audioCtx;
    FEATURE_NAME_MFCC = 'mfcc'
    FEATURE_NAME_RMS = 'rms'

    cur_mfcc = this.DEFAULT_MFCC_VALUE
    cur_rms = 0
    mfcc_history = []
    constructor() {
        
    }
    // 获取浏览器上audio的上下文
    createAudioCtx() {
        let AudioContext = window.AudioContext || window.webkitAudioContext;
        return new AudioContext();
    }
    createMicSrcFrom(audioCtx) {
        /* get microphone access */
        return new Promise((resolve, reject) => {
            /* only audio */
            let constraints = { audio: true, video: false }

            navigator.mediaDevices.getUserMedia(constraints)
                .then((stream) => {
                    /* create source from
                    microphone input stream */
                    let src = audioCtx.createMediaStreamSource(stream)
                    resolve(src)
                }).catch((err) => { reject(err) })
        })
    }

    onMicDataCall(features, callback) {
        return new Promise((resolve, reject) => {
            this.audioCtx = this.createAudioCtx()

            this.createMicSrcFrom(this.audioCtx)
                .then((src) => {
                    console.log("window.Meyda");
                    console.log(Meyda);
                    console.log("window.Meyda");
                    let analyzer = Meyda.createMeydaAnalyzer({
                        'audioContext': this.audioCtx,
                        'source': src,
                        'bufferSize': 512,
                        'featureExtractors': features,
                        'callback': callback
                    })
                    resolve(analyzer)
                }).catch((err) => {
                    reject(err)
                })
        })
    }

    _show(features) {
        console.log(features);
        // update spectral data size
        this.cur_mfcc = features[this.FEATURE_NAME_MFCC]
        this.cur_rms = features[this.FEATURE_NAME_RMS]
    }

    startReocrd() {
        this.stopReocrd();
        this.onMicDataCall([this.FEATURE_NAME_MFCC, this.FEATURE_NAME_RMS], this._show)
            .then((meydaAnalyzer) => {
                meydaAnalyzer.start()
            }).catch((err) => {
                alert(err)
            })
    }



    stopReocrd() {
        if (this.audioCtx) {
            this.audioCtx.close();
            this.audioCtx = null;
        }
    }

};

window.voiceEcho = new VoiceEcho();
window.voiceEchoStart = () => {
    window.voiceEcho.startReocrd();
}

window.voiceEchoStop = () => {
    window.voiceEcho.stopReocrd();
}


// window.onload = ()=>{
//     var Meyda = require('meyda');

// }
