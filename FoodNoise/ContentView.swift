// ContentView.swift
import SwiftUI
import AVFoundation
import UserNotifications

struct ContentView: View {
    var body: some View {
        TabView {
            BuzzerView()
                .tabItem {
                    Label("Buzzer", systemImage: "bolt.fill")
                }

            ChallengeView()
                .tabItem {
                    Label("Challenges", systemImage: "target")
                }

            MindfulnessView()
                .tabItem {
                    Label("Mindfulness", systemImage: "brain.head.profile")
                }
        }
    }
}

// MARK: - BuzzerView
struct BuzzerView: View {
    @State private var quote = "Drück auf den Buzzer!"
    @State private var player: AVAudioPlayer?

    let quotes = [
        "STOP! Denk an deine Ziele 💅",
        "Iss 'ne Karotte, nicht deine Gefühle 😌",
        "Du bist kein Staubsauger – hör auf alles aufzusaugen! 🧹",
        "Willst du Essen oder fliehen? Fight the binge! ⚔️",
        "Wär Kim Kardashian schwach? NEIN! 😤",
        "Atme tief ein... und dann SLAY den Tag! ✨",
        "Vielleicht hast du einfach nur Durst – duh? 💧",
        "Zieh 5 Minuten durch – alles ändert sich! 🕒",
        "Du bist stärker als dein Snack-Verlangen 💥",
        "Genau JETZT ist der Moment der Veränderung."
    ]

    var body: some View {
        ZStack {
            Color.pink.opacity(0.15).ignoresSafeArea()

            VStack {
                Spacer().frame(height: 80)

                Text(quote)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.pink)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .animation(.easeInOut, value: quote)

                Spacer()

                Button(action: {
                    playSound()
                    quote = quotes.randomElement() ?? quote
                }) {
                    Text("SLAY BUZZER")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 280, height: 120)
                        .background(Color.pink)
                        .cornerRadius(20)
                        .shadow(radius: 15)
                }

                Spacer()
            }
            .padding()
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "buzzer1", withExtension: "mp3") else {
            print("Sounddatei nicht gefunden!")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Fehler beim Abspielen: \(error.localizedDescription)")
        }
    }
}

// MARK: - ChallengeView
struct ChallengeView: View {
    @State private var currentChallenge = "Drück auf den Button für deine Ablenkungs-Challenge!"
    @State private var timeRemaining = 180
    @State private var timerRunning = false
    @State private var timer: Timer?

    let challengesWithTime: [(String, Int)] = [
        ("3 Minuten Ablenkung", 180),
        ("1 Minute Hampelmänner", 60),
        ("3 Dinge, für die du dankbar bist", 120),
        ("Sing ein Lied für 2 Minuten", 120),
        ("Male etwas für 5 Minuten", 300),
        ("Recherchiere ein random Thema", 180),
        ("Mood-Challenge: Affirmation wählen", 150)
    ]

    var body: some View {
        ZStack {
            Color.pink.opacity(0.1).ignoresSafeArea()

            VStack(spacing: 30) {
                Text("🎯 Deine Challenge")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 40)

                Text(currentChallenge)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)

                Button("Neue Challenge") {
                    let random = challengesWithTime.randomElement()!
                    currentChallenge = random.0
                    timeRemaining = random.1
                    resetTimer()
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.pink)
                .cornerRadius(15)
                .shadow(radius: 10)

                VStack(spacing: 15) {
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.pink)

                    HStack(spacing: 40) {
                        Button(timerRunning ? "Stop" : "Start") {
                            timerRunning ? stopTimer() : startTimer()
                        }
                        .font(.title3)
                        .padding()
                        .background(timerRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                        Button("Reset") {
                            resetTimer()
                        }
                        .font(.title3)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }

    func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }

    func resetTimer() {
        stopTimer()
    }
}

// MARK: - MindfulnessView
struct MindfulnessStep: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    var journalEntry: String = ""
}

class MindfulnessViewModel: ObservableObject {
    @Published var steps: [MindfulnessStep] = [
        MindfulnessStep(title: "1. Notice the Urge", description: "Become aware of what triggers your habit. Is it stress? Boredom? A craving? Notice it without judging."),
        MindfulnessStep(title: "2. Get Curious", description: "Don't resist the urge. Just explore it. What does it feel like in your body? What do you really get out of the habit?"),
        MindfulnessStep(title: "3. Feel the Joy of Letting Go", description: "By becoming aware instead of reacting, you create space. And in that space, joy arises. This is freedom."),
        MindfulnessStep(title: "4. Repeat to Find Freedom", description: "Every time you repeat this mindful loop, you weaken the habit's grip. Over time, you transform.")
    ]

    @Published var currentStepIndex: Int = 0
    @Published var history: [String] = []

    func nextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        } else {
            history.append("Completed on \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))")
            currentStepIndex = 0
        }
    }
}

struct MindfulnessView: View {
    @StateObject private var viewModel = MindfulnessViewModel()

    var body: some View {
        let step = viewModel.steps[viewModel.currentStepIndex]

        VStack(spacing: 30) {
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Text(step.description)
                .font(.title3)
                .padding()
                .multilineTextAlignment(.center)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)

            TextEditor(text: Binding(
                get: { viewModel.steps[viewModel.currentStepIndex].journalEntry },
                set: { viewModel.steps[viewModel.currentStepIndex].journalEntry = $0 }
            ))
            .frame(height: 150)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)

            Button(action: viewModel.nextStep) {
                Text(viewModel.currentStepIndex < viewModel.steps.count - 1 ? "Next" : "Finish & Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            List {
                Section(header: Text("History")) {
                    ForEach(viewModel.history, id: \ .self) { item in
                        Text(item)
                    }
                }
            }
            .frame(height: 150)

            Spacer()
        }
        .padding()
        .onAppear {
            NotificationManager.shared.scheduleDailyReminder()
        }
    }
}

// MARK: - NotificationManager
class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Mindfulness Time 🧘‍♀️"
                content.body = "Take 5 minutes to observe, get curious, and journal."

                var dateComponents = DateComponents()
                dateComponents.hour = 9

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                let request = UNNotificationRequest(identifier: "daily_mindfulness", content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
}
