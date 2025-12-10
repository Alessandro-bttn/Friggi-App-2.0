# 📱 Friggi-App (Gestione Spese) - Dev Log

Questo documento traccia lo stato di avanzamento dello sviluppo dell'app per la gestione spese/locali.

## ✅ Stato Attuale (Funzionalità Implementate)

### 1. Architettura e Navigazione 🧭
* **Root Page System:** Implementato uno "smistatore" iniziale (`RootPage`) che decide quale pagina mostrare all'avvio.
* **Logica di Avvio:**
    * Se il DB è vuoto/inesistente → Vai a `NewLocale`.
    * Se il DB ha dati → Vai a `MonthPage`.
* **Loading State:** Gestione tramite `FutureBuilder` con indicatore di caricamento durante i controlli iniziali.

### 2. Database Locale (SQLite) 🗄️
* **Libreria:** `sqflite` + `path_provider`.
* **Struttura Tabella `items`:**
    * `id` (Auto-increment)
    * `nome` (String)
    * `pd` (Ruolo: Responsabile/Dipendente)
    * `imagePath` (Stringa del percorso file)
* **Funzionalità:**
    * Creazione automatica DB.
    * Inserimento dati (`insertItem`).
    * Conteggio righe per controllo avvio (`hasData`).
    * Cancellazione sicura per reset e debug (`deleteDB`).

### 3. Gestione Media (Immagini) 📸
* **Selezione:** Integrazione con `image_picker` per selezionare foto dalla Galleria.
* **Salvataggio Permanente:** Implementato `ImageHelper` (`utils/image_helper.dart`).
    * Le foto **non** vengono salvate come BLOB nel DB.
    * Vengono copiate dalla cache alla cartella sicura dell'app (`ApplicationDocumentsDirectory`).
    * Nel DB viene salvato solo il percorso (`path`).

### 4. Localizzazione (Multilingua) 🌍
* **Sistema:** `flutter_localizations` con file `.arb`.
* **Lingue Supportate:** Italiano (default), Inglese.
* **Gestione Dinamica:** `LanguageController` per cambiare lingua a runtime senza riavviare.
* **Widget:** Tutte le stringhe UI sono state migrate per usare `AppLocalizations`.

### 5. Interfaccia Utente (UI/UX) 🎨
* **Pagina `NewLocale`:**
    * Form validato per inserimento dati.
    * Anteprima immagine selezionata con bordi arrotondati (`ClipRRect`).
* **Componenti Custom:**
    * `RoleSelector`: Menu a tendina (Dropdown) isolato in un widget dedicato per la selezione del ruolo (Responsabile/Dipendente).

### 6. Preferenze Globali ⚙️
* **Service:** Creato `PreferencesService` (Singleton) basato su `shared_preferences`.
* **Scopo:** Sistema centralizzato per salvare impostazioni persistenti (Tema, Lingua salvata, Username) accessibile da qualsiasi punto dell'app.

---

## 📂 Struttura del Progetto

```text
lib/
├── database/
│   ├── LocaleDB.dart       # Gestione SQLite (Singleton)
│   └── LocaleModel.dart    # Modello dati (ItemModel)
├── l10n/
│   ├── app_it.arb          # Traduzioni Italiano
│   ├── app_en.arb          # Traduzioni Inglese
│   └── l10n.yaml           # Configurazione generatore
├── pages/
│   ├── new_locale.dart     # Form creazione locale
│   └── month_page.dart     # Dashboard principale (Placeholder)
├── services/
│   └── preferences_service.dart # Gestione impostazioni globali
├── utils/
│   └── image_helper.dart   # Logica salvataggio file fisici
├── widgets/
│   └── role_selector.dart  # Dropdown menu custom
├── main.dart               # Configurazione App e Provider Lingua
└── root_page.dart          # Logica di smistamento iniziale