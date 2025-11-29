"use client"

import { useState } from "react"
import PatientNavigation from "./components/PatientNaviguation"
import PatientDashboard from "./components/Dashboard"
import SymptomAnalysis from "./components/SymptomAnalysis"
import AIResults from "./components/Result"
import AnalysisHistory from "./components/History"
import NotificationsCenter from "./components/Notifications"
import UserProfile from "./components/Profile"

export default function PatientPage() {
  const [currentScreen, setCurrentScreen] = useState("dashboard")
  const [analysisData, setAnalysisData] = useState(null)
  const [selectedAnalysis, setSelectedAnalysis] = useState(null)

  const handleScreenChange = (screen) => {
    setCurrentScreen(screen)
  }

  const handleAnalysisSubmit = (data) => {
    setAnalysisData(data)
    setCurrentScreen("results")
  }

  const handleResultsSave = () => {
    // Après sauvegarde, retour au dashboard
    setTimeout(() => setCurrentScreen("dashboard"), 1000)
  }

  const handleSelectAnalysis = (analysis) => {
    setSelectedAnalysis(analysis)
    setCurrentScreen("analysis-detail")
  }

  const renderContent = () => {
    switch (currentScreen) {
      case "dashboard":
        return (
          <PatientDashboard
            onAnalysisClick={() => setCurrentScreen("analysis")}
            onHistoryClick={() => setCurrentScreen("history")}
          />
        )
      case "analysis":
        return <SymptomAnalysis onResultsReady={handleAnalysisSubmit} />
      case "results":
        return (
          <AIResults
            analysisData={analysisData}
            onSave={handleResultsSave}
            onBackClick={() => setCurrentScreen("dashboard")}
          />
        )
      case "history":
        return (
          <AnalysisHistory onSelectAnalysis={handleSelectAnalysis} onNewAnalysis={() => setCurrentScreen("analysis")} />
        )
      case "notifications":
        return <NotificationsCenter />
      case "profile":
        return (
          <UserProfile
            onLogout={() => {
              // TODO: Redirigez vers la page de connexion
              setCurrentScreen("dashboard")
            }}
          />
        )
      default:
        return <PatientDashboard />
    }
  }

  return (
    <PatientNavigation currentScreen={currentScreen} onScreenChange={handleScreenChange} userName="Jean Dupont">
      <div className="patient-main">{renderContent()}</div>
    </PatientNavigation>
  )
}
