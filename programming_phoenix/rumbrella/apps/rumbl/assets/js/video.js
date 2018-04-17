import Player from "./player"

const Video = {
  init(socket, element) {
    if (!element) {
      return
    }

    const playerId = element.getAttribute("data-player-id")
    const videoId = element.getAttribute("data-id")
    socket.connect()
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket) {
    const msgContainer = document.getElementById("msg-container")
    const msgInput = document.getElementById("msg-input")
    const postButton = document.getElementById("msg-submit")
    const vidChannel = socket.channel(`videos:${videoId}`)

    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel.push("new_annotation", payload)
        .receive("ok", () => msgInput.value = '')
        .receive("error", console.log)
    })

    vidChannel.on("new_annotation", resp => {
      vidChannel.params.last_seen_id = resp.id
      this.renderAnnotation(msgContainer, resp)
    })

    this.setupMessageSeek(msgContainer)

    vidChannel.join()
      .receive("ok", ({annotations}) => {
        let ids = annotations.map(annotation => annotation.id)
        if (ids.length > 0) {
          vidChannel.params.last_seen_id = Math.max(...ids)
          this.scheduleMessages(msgContainer, annotations)
        }
      })
      .receive("error", reason => console.log("join failed", reason))
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    let template = document.createElement("div")
    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        [${this.formatTime(at)}]
        <b>${this.esc(user.username)}</b>: ${this.esc(body)}
      </a>
    `

    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      let playerTime = Player.getCurrentTime()
      let remaining = this.renderAtTime(annotations, playerTime, msgContainer)
      this.scheduleMessages(msgContainer, remaining)
    }, 1000)
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter(annotation => {
      if (annotation.at > seconds) {
        return true
      } else {
        this.renderAnnotation(msgContainer, annotation)
        return false
      }
    })
  },

  formatTime(at) {
    let date = new Date(null)
    date.setSeconds(at / 1000)
    return date.toISOString().substr(14, 5)
  },

  esc(str) {
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  setupMessageSeek(msgContainer) {
    msgContainer.addEventListener("click", e => {
      e.preventDefault()
      let seconds =
          e.target.getAttribute("data-seek")
          || e.target.parentNode.getAttribute("data-seek")

      if (seconds) {
        Player.seekTo(seconds)
      }
    })
  }
}

export default Video