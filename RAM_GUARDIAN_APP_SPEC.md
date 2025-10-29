# RAM Guardian - Custom Kotlin App Specification

## Purpose
Automatic RAM cleanup app with threshold-based triggering and whitelist support.

## Requirements Met
1. ✅ Whitelist apps that should never be killed (Termux, system apps)
2. ✅ System-wide operation (no Termux session needed)
3. ✅ Works independently of Termux
4. ✅ **Automatic trigger when RAM threshold is met**

## Core Features

### 1. Automatic RAM Monitoring
- **Service:** ForegroundService (exempt from Android Doze)
- **Frequency:** Check RAM every 30 seconds (configurable)
- **Threshold:** Default 500 MB available (configurable 300-1000 MB)
- **Action:** When RAM < threshold → kill RAM hogs (except whitelist)

### 2. Whitelist Management
- **UI:** Settings screen with app checkboxes
- **Default whitelist:**
  - com.termux (Termux)
  - com.android.systemui (System UI)
  - Current app (self)
  - System apps with FLAG_SYSTEM
- **Persistent:** Save to SharedPreferences

### 3. Smart RAM Hog Detection
- Query ActivityManager.getRunningAppProcesses()
- Get RSS (Resident Set Size) per process
- Sort by memory descending
- Exclude whitelisted apps
- Kill top N hogs until RAM > threshold + 200 MB buffer

### 4. User Interface

#### MainActivity
- Current RAM status (available/total)
- Threshold slider (300-1000 MB)
- Auto-cleanup toggle
- Whitelist button → WhitelistActivity
- Manual "Clean Now" button
- Statistics (last cleanup, apps killed, RAM freed)

#### WhitelistActivity
- RecyclerView with all installed apps
- Checkbox for each app
- Filter: Show running apps only / All apps
- Search bar

#### HomeScreenWidget
- Shows current available RAM
- Tap to trigger manual cleanup
- Long-press to open settings

### 5. Notifications
- **Persistent (required for ForegroundService):**
  - "RAM Guardian monitoring"
  - Shows current available RAM
  - Tap to open app
- **Cleanup notifications:**
  - "Freed 234 MB by killing 3 apps"
  - Expandable to show which apps
  - Auto-dismiss after 5 seconds

## Technical Implementation

### Permissions Required
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.KILL_BACKGROUND_PROCESSES" />
<uses-permission android:name="android.permission.GET_TASKS" />
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
```

### Key Classes

#### 1. RamMonitorService.kt
```kotlin
class RamMonitorService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private val checkInterval = 30_000L // 30 seconds

    private val ramChecker = object : Runnable {
        override fun run() {
            val availableRam = getAvailableMemory()
            if (availableRam < threshold) {
                killRamHogs()
            }
            handler.postDelayed(this, checkInterval)
        }
    }

    private fun getAvailableMemory(): Long {
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        return memInfo.availMem / (1024 * 1024) // Convert to MB
    }

    private fun killRamHogs() {
        val processes = getRunningProcesses()
            .filter { !isWhitelisted(it.packageName) }
            .sortedByDescending { getProcessMemory(it.pid) }
            .take(5) // Top 5 RAM hogs

        processes.forEach { process ->
            activityManager.killBackgroundProcesses(process.packageName)
        }

        showCleanupNotification(processes.size, freedMemory)
    }
}
```

#### 2. WhitelistManager.kt
```kotlin
object WhitelistManager {
    private const val PREFS_NAME = "ram_guardian_whitelist"
    private const val KEY_WHITELIST = "whitelist_apps"

    fun getWhitelist(context: Context): Set<String> {
        val prefs = context.getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
        return prefs.getStringSet(KEY_WHITELIST, defaultWhitelist) ?: defaultWhitelist
    }

    fun addToWhitelist(context: Context, packageName: String) {
        val whitelist = getWhitelist(context).toMutableSet()
        whitelist.add(packageName)
        saveWhitelist(context, whitelist)
    }

    private val defaultWhitelist = setOf(
        "com.termux",
        "com.android.systemui",
        BuildConfig.APPLICATION_ID // Self
    )
}
```

#### 3. MainActivity.kt
```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var ramMonitor: RamMonitorViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Threshold slider
        binding.thresholdSlider.addOnChangeListener { _, value, _ ->
            ramMonitor.setThreshold(value.toInt())
        }

        // Auto-cleanup toggle
        binding.autoCleanupToggle.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                startRamMonitorService()
            } else {
                stopRamMonitorService()
            }
        }

        // Manual cleanup button
        binding.cleanNowButton.setOnClickListener {
            ramMonitor.triggerManualCleanup()
        }
    }
}
```

### Battery Optimization
- Request battery optimization exemption on first launch
- Use AlarmManager.setRepeating() instead of handler.postDelayed() for better battery
- Wake lock only during cleanup (< 1 second)

### Project Structure
```
app/
├── src/main/
│   ├── java/com/ramguardian/
│   │   ├── service/
│   │   │   ├── RamMonitorService.kt
│   │   │   └── CleanupWorker.kt
│   │   ├── ui/
│   │   │   ├── MainActivity.kt
│   │   │   ├── WhitelistActivity.kt
│   │   │   └── adapters/AppListAdapter.kt
│   │   ├── data/
│   │   │   ├── WhitelistManager.kt
│   │   │   ├── RamMonitor.kt
│   │   │   └── AppInfo.kt
│   │   └── widget/
│   │       └── RamGuardianWidget.kt
│   ├── res/
│   │   ├── layout/
│   │   │   ├── activity_main.xml
│   │   │   ├── activity_whitelist.xml
│   │   │   └── item_app.xml
│   │   └── values/
│   │       ├── strings.xml
│   │       └── themes.xml
│   └── AndroidManifest.xml
└── build.gradle.kts
```

## Development Timeline

### Phase 1: Core Service (Day 1 - 2 hours)
- [ ] RamMonitorService with basic RAM checking
- [ ] Kill background processes (no whitelist yet)
- [ ] Foreground notification

### Phase 2: Whitelist (Day 1 - 1.5 hours)
- [ ] WhitelistManager with SharedPreferences
- [ ] Default whitelist (Termux, system)
- [ ] Integration with service

### Phase 3: UI (Day 2 - 2 hours)
- [ ] MainActivity with threshold slider
- [ ] Toggle for auto-cleanup
- [ ] RAM statistics display
- [ ] Manual cleanup button

### Phase 4: Whitelist UI (Day 2 - 1.5 hours)
- [ ] WhitelistActivity with RecyclerView
- [ ] App list with checkboxes
- [ ] Save/load whitelist

### Phase 5: Widget & Polish (Day 3 - 2 hours)
- [ ] Home screen widget
- [ ] Cleanup notifications
- [ ] Battery optimization request
- [ ] App icon and branding

### Phase 6: Testing (Day 3 - 1 hour)
- [ ] Test on Android 8+ (background restrictions)
- [ ] Verify whitelist persistence
- [ ] Battery drain testing
- [ ] Edge cases (rapid kills, no RAM hogs, etc.)

**Total: ~10 hours** (spread over 3 days)

## Alternative: Minimal Version (3 hours)

If time-constrained, build minimal version:
- [ ] Service with RAM monitoring (1 hour)
- [ ] Hardcoded whitelist (Termux only) (15 min)
- [ ] Simple notification (no UI) (30 min)
- [ ] Home screen shortcut (not widget) (15 min)
- [ ] Basic testing (1 hour)

**Total: 3 hours** - No GUI, but functional

## Dependencies
```kotlin
// build.gradle.kts
dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.work:work-runtime-ktx:2.9.0") // For WorkManager
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
}
```

## Deployment
- **Build:** Android Studio / Gradle
- **Install:** ADB or F-Droid repo (if publish)
- **APK size:** ~2-3 MB
- **Min SDK:** Android 8.0 (API 26)
- **Target SDK:** Android 14 (API 34)

## Future Enhancements
- [ ] Profiles (e.g., "Work mode" vs "Gaming mode" whitelists)
- [ ] Scheduling (e.g., "Aggressive cleanup at night")
- [ ] Statistics dashboard (graphs, trends)
- [ ] Export/import whitelist
- [ ] Tasker integration
- [ ] Root mode (more aggressive killing)

## Notes
- Must request battery optimization exemption (otherwise service killed by Doze)
- Android 12+ requires ForegroundService type declaration
- QUERY_ALL_PACKAGES requires Play Store declaration (or F-Droid)
- Test on multiple Android versions (fragmentation)
