"use client"

import { useState } from "react"

export function NotificationsCenter() {
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      type: "info",
      title: "Rappel de santé",
      message: "N'oubliez pas de boire de l'eau régulièrement",
      timestamp: "Il y a 2h",
      read: false,
    },
    {
      id: 2,
      type: "alert",
      title: "Alerte importante",
      message: "Surveillez votre température si la fièvre persiste",
      timestamp: "Il y a 4h",
      read: false,
    },
    {
      id: 3,
      type: "success",
      title: "Mise à jour complétée",
      message: "Votre historique d'analyses a été mis à jour",
      timestamp: "Il y a 1 jour",
      read: true,
    },
    {
      id: 4,
      type: "info",
      title: "Rappel de consultation",
      message: "Pensez à vérifier votre suivi médical régulier",
      timestamp: "Il y a 2 jours",
      read: true,
    },
  ])

  const markAsRead = (id) => {
    setNotifications((prev) => prev.map((notif) => (notif.id === id ? { ...notif, read: true } : notif)))
  }

  const deleteNotification = (id) => {
    setNotifications((prev) => prev.filter((notif) => notif.id !== id))
  }

  const unreadCount = notifications.filter((n) => !n.read).length

  const getIcon = (type) => {
    switch (type) {
      case "alert":
        return "⚠️"
      case "success":
        return "✅"
      case "info":
      default:
        return "ℹ️"
    }
  }

  return (
    <div className="notifications-center fade-in">
      <div className="notifications-container">
        <h2 className="section-title">Notifications</h2>
        <p className="section-subtitle">
          {unreadCount > 0
            ? `Vous avez ${unreadCount} notification${unreadCount > 1 ? "s" : ""} non lue${unreadCount > 1 ? "s" : ""}`
            : "Aucune notification non lue"}
        </p>

        <div className="notifications-list">
          {notifications.length === 0 ? (
            <div className="empty-state">
              <p>Aucune notification pour le moment</p>
            </div>
          ) : (
            notifications.map((notif) => (
              <div key={notif.id} className={`notification-card ${notif.read ? "read" : "unread"}`}>
                <div className="notification-icon">{getIcon(notif.type)}</div>
                <div className="notification-content">
                  <h4 className="notification-title">{notif.title}</h4>
                  <p className="notification-message">{notif.message}</p>
                  <span className="notification-time">{notif.timestamp}</span>
                </div>
                <div className="notification-actions">
                  {!notif.read && (
                    <button className="action-btn" onClick={() => markAsRead(notif.id)} title="Marquer comme lu">
                      ✓
                    </button>
                  )}
                  <button
                    className="action-btn delete-btn"
                    onClick={() => deleteNotification(notif.id)}
                    title="Supprimer"
                  >
                    ✕
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  )
}

export default NotificationsCenter
