import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    userId: Number,
    roomId: Number,
    heartbeatInterval: { type: Number, default: 30000 }
  }
  
  connect() {
    this.startHeartbeat()
    this.updateStatus('online')
    
    // Handle page visibility changes
    document.addEventListener('visibilitychange', this.handleVisibilityChange.bind(this))
    window.addEventListener('beforeunload', this.handleBeforeUnload.bind(this))
  }
  
  disconnect() {
    this.stopHeartbeat()
    this.updateStatus('offline')
    
    document.removeEventListener('visibilitychange', this.handleVisibilityChange.bind(this))
    window.removeEventListener('beforeunload', this.handleBeforeUnload.bind(this))
  }
  
  startHeartbeat() {
    this.heartbeatTimer = setInterval(() => {
      this.sendHeartbeat()
    }, this.heartbeatIntervalValue)
  }
  
  stopHeartbeat() {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer)
      this.heartbeatTimer = null
    }
  }
  
  sendHeartbeat() {
    fetch('/presence/heartbeat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_id: this.userIdValue,
        room_id: this.roomIdValue
      })
    })
  }
  
  updateStatus(status) {
    fetch('/presence/update', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        status: status,
        room_id: this.roomIdValue
      })
    })
  }
  
  handleVisibilityChange() {
    if (document.hidden) {
      this.updateStatus('away')
      this.stopHeartbeat()
    } else {
      this.updateStatus('online')
      this.startHeartbeat()
    }
  }
  
  handleBeforeUnload() {
    this.updateStatus('offline')
  }
}
