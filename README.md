# who-opened-the-cmd-
# CMD Trap – Beta V2  
Un potente strumento di diagnostica per Windows progettato per identificare l'origine di aperture improvvise di `cmd.exe` causate da servizi o applicazioni in background.  
CMD Trap monitora in tempo reale ogni processo cmd.exe e registra comando, processo genitore, ora e dettagli utili per tracciare comportamenti indesiderati.

---

## 🚀 Funzionalità principali
- Monitoraggio in tempo reale (500 ms)
- Log dettagliati di:
  - CommandLine
  - ProcessID (PID)
  - ParentProcess e ParentCommand
  - Timestamp completo
- Filtraggio dei duplicati (evita log ripetuti)
- Zero impatto sul sistema (read-only)
- Compatibile con Windows 10 / 11
- Nessuna installazione richiesta

---

## 📦 Installazione
1. Scarica il file `cmd_trap_beta_v2.ps1`
2. Posizionalo sul Desktop o nella cartella che preferisci
3. Apri PowerShell come amministratore

---

## ▶️ Utilizzo
Esegui il comando:

```powershell
& "$env:USERPROFILE\Desktop\cmd_trap_beta_v2.ps1"
