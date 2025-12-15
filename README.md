# 📱 Friggi-App - Gestione Locali & Turni

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

Un'applicazione gestionale completa sviluppata in Flutter per l'amministrazione di più locali commerciali, gestione dipendenti, turni di lavoro e monitoraggio spese. Progettata con un'architettura modulare e un database locale relazionale.

## ✨ Funzionalità Principali

### 🏢 Gestione Locali
* **Multi-Store:** Gestione di più punti vendita con database unico centralizzato.
* **Media Management:** Salvataggio e gestione foto dei locali (Image Picker + File System locale).
* **Ruoli:** Distinzione tra Responsabili e Dipendenti.

### 👥 Gestione Dipendenti
* **CRUD Completo:** Aggiunta, modifica ed eliminazione dipendenti.
* **Ricerca Istantanea:** Filtro in tempo reale per nome/cognome.
* **Personalizzazione:** Assegnazione colori personalizzati (Color Picker avanzato) per i turni.
* **Relazionalità:** Ogni dipendente è legato dinamicamente al locale attivo.

### 📅 Calendario Avanzato & Navigazione
* **Vista Mensile:** Griglia classica con swipe orizzontale.
* **Vista Settimanale (2x4):** Layout ottimizzato su due righe per la massima leggibilità.
* **Gesture Navigation:**
  * **Pinch-to-Zoom:** Transizione fluida da Mese a Settimana (Zoom In) e viceversa (Zoom Out).
  * **Swipe:** Navigazione temporale intuitiva in tutte le viste.

### ⚙️ Altro
* **Localizzazione:** Supporto nativo multilingua (IT/EN) tramite file `.arb`.
* **Dark Mode:** Supporto al tema scuro di sistema.
* **Persistenza:** `SharedPreferences` per le impostazioni utente e `SQLite` per i dati strutturati.

---

## 🛠️ Tech Stack

| Categoria | Tecnologia | Dettagli |
| :--- | :--- | :--- |
| **Framework** | Flutter | 3.x (Dart) |
| **Database** | SQFlite | Relazionale, Tabelle `locali` e `dipendenti` |
| **State Mngt** | `setState` / Provider | Gestione logica separata (Logic Classes) |
| **UI Kit** | Material 3 | Design system moderno |
| **Utils** | `intl`, `path_provider` | Formattazione date e gestione file |

---

## 📂 Struttura del Progetto

Il progetto segue una struttura modulare basata sulle funzionalità ("Feature-first"):

```text
lib/
├── DataBase/               # Layer Dati (SQLite)
│   ├── Dipendente/         # DB e Model Dipendenti
│   └── Locale/             # DB e Model Locali
├── Dipendenti/             # Feature: Gestione Dipendenti
│   ├── logic/              # Business Logic (Salvataggio, Filtri)
│   └── widgets/            # Componenti UI (Card, Form, ColorPicker)
├── MonthPage/              # Feature: Calendario Mensile
│   ├── logic/              # Logica date
│   └── widgets/            # Gesture Detector, AppDrawer
├── WeekPage/               # Feature: Calendario Settimanale
│   ├── logic/              # Calcolo settimane
│   └── widgets/            # Griglia 2x4, WeekGestureDetector
├── l10n/                   # File di traduzione (.arb)
├── service/                # Servizi globali (Preferences)
└── main.dart               # Entry point