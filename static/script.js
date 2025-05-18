const thoughts = [
    "Ich will Schokolade...",
    "Kühlschrank aufmachen?",
    "Nur ein Snack...",
    "Ich habe Langeweile.",
    "Ich hab Stress, etwas Süßes?"
];

const actions = [
    "Atme tief durch.",
    "Trinke ein Glas Wasser.",
    "Geh 1 Minute spazieren.",
    "Mach 5 Kniebeugen.",
    "Denk an dein Ziel."
];

let score = 0;

function randomItem(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function showStimulus() {
    document.getElementById("stimulus").innerText = randomItem(thoughts);
    document.getElementById("tip").innerText = "";
}

function blockStimulus() {
    score += 1;
    document.getElementById("score").innerText = "Punkte: " + score;
    document.getElementById("tip").innerText = "💡 " + randomItem(actions);
    setTimeout(showStimulus, 2000);
}

window.onload = showStimulus;
