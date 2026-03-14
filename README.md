# 🧮 Math Auto Answer

A Roblox script that reads math questions from in-game screens, solves them instantly, and types the answer into the textbox — with human-like keystroke emulation.

Built with **Clean UI**, a custom minimal UI library.

![Lua](https://img.shields.io/badge/Lua-2C2D72?style=flat&logo=lua&logoColor=white)
![Roblox](https://img.shields.io/badge/Roblox-00A2FF?style=flat&logo=roblox&logoColor=white)

---

## ✨ Features

- **Auto Math Solver** — Parses and solves `+`, `-`, `*`, `/`, `^`, parentheses
- **Human-Like Typing** — Types answer character by character with random delays
- **Smart Question Detection** — Watches for new questions, answers once per round
- **Enter Key Simulation** — Submits via VirtualInputManager, firesignal, or ReleaseFocus
- **Clean UI** — Draggable window with tabs, toggles, sliders, notifications
- **Universal** — Works on any account (no hardcoded usernames)
- **Non-Blocking** — GUI loads instantly, question path found lazily
- **Anti-Duplicate** — Won't re-answer the same question twice

---

## 📁 File Structure

```
MathAnswerBot/
├── README.md              ← You are here
├── main.lua               ← Full single-file script
└── src/
    ├── config.lua          ← Colors, sizes, fonts, keybinds
    ├── utility.lua         ← Tween, Create, AddCorner helpers
    ├── gui_core.lua        ← ScreenGui, MainFrame, shadow, dragging
    ├── gui_topbar.lua      ← Top bar, close/minimize buttons
    ├── gui_sidebar.lua     ← Sidebar + content area
    ├── notifications.lua   ← Notification popup system
    ├── tab_system.lua      ← Tab library (AddTab, AddToggle, AddSlider, etc.)
    ├── math_parser.lua     ← Recursive descent math solver (no loadstring)
    ├── game_finder.lua     ← Finds QuestionText label and answer TextBox
    ├── input_emulator.lua  ← Typing emulation + Enter key simulation
    ├── auto_answer.lua     ← Main loop + state management
    └── tabs_setup.lua      ← Home tab, Settings tab, UI wiring
```

> **Note:** The `src/` files are for reading/reference. Since Roblox executors run single files,
> use **`main.lua`** — it contains everything combined into one script.

---

## 🚀 Usage

1. Join the target game
2. Open your executor (Synapse, Fluxus, Wave, Solara, etc.)
3. Paste the contents of `main.lua` and execute
4. Toggle **Auto Answer** in the Home tab
5. Adjust typing speed with the sliders if needed

**Keybind:** Press `RightShift` to show/hide the UI

---

## ⚙️ Configuration

Edit the `CONFIG` table at the top of `main.lua` (or `src/config.lua`) to customize:

| Setting | Default | Description |
|---------|---------|-------------|
| `ToggleKey` | `RightShift` | Key to show/hide UI |
| `WindowWidth` | `520` | UI window width |
| `WindowHeight` | `380` | UI window height |
| `Accent` | `RGB(88, 101, 242)` | Accent color (indigo) |
| `TweenSpeed` | `0.3` | Animation speed |

---

## 🎯 Game Path

The script reads from:
```
workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer.QuestionText
```

And types into:
```
PlayerGui.MainGui.MainFrame.GameFrame.PCTextBoxContainer.TextBox
```

If your game uses different paths, edit `FindQuestionLabel()` and `FindAnswerBox()` in `src/game_finder.lua` (or the corresponding section in `main.lua`).

---

## 🛡️ Executor Compatibility

| Feature | Synapse X | Fluxus | Wave | Solara | Script-Ware |
|---------|-----------|--------|------|--------|-------------|
| GUI | ✅ | ✅ | ✅ | ✅ | ✅ |
| Math Parser | ✅ | ✅ | ✅ | ✅ | ✅ |
| VirtualInputManager | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| firesignal | ✅ | ✅ | ✅ | ❔ | ✅ |
| gethui | ✅ | ✅ | ✅ | ❔ | ✅ |

The script tries multiple input methods automatically — if one fails, it falls back to the next.

---

## 📜 License

Do whatever you want with it. No license, no restrictions.

## Loader
Find the loader for the script here:

```
loadstring(game:HttpGet("https://raw.githubusercontent.com/blinkednextnona/AutoMathAnswer/main/main.lua"))()
```
