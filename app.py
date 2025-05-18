from flask import Flask, render_template_string
import random

app = Flask(__name__)

motivations = [
    "Stop! ✋ Think about your goals. 🎯",
    "Do you really want that... or are you just bored? 🤔",
    "Remember: abs are made in the kitchen. 💪",
    "That snack won’t fix the mood — but self-love will. 💖",
    "Girl, you got this! 🌸✨",
    "Hydrate, then reevaluate. 💧",
    "Walk it off, queen 👑"
]

@app.route('/')
def home():
    quote = random.choice(motivations)
    return render_template_string(f"""
    <html>
    <head>
        <title>FOOD DEFENDER</title>
        <style>
            body {{
                background-color: #ffe6f0;
                font-family: 'Comic Sans MS', cursive, sans-serif;
                text-align: center;
                padding-top: 50px;
            }}
            h1 {{
                color: #ff4d88;
                font-size: 48px;
                animation: shake 0.4s infinite alternate;
            }}
            p {{
                font-size: 24px;
                color: #333;
                margin-top: 30px;
            }}
            button {{
                background-color: #ff66b2;
                color: white;
                font-size: 22px;
                border: none;
                padding: 15px 30px;
                border-radius: 12px;
                cursor: pointer;
                margin-top: 40px;
            }}
            button:hover {{
                background-color: #ff3385;
            }}
            @keyframes shake {{
                0% {{ transform: rotate(-2deg); }}
                100% {{ transform: rotate(2deg); }}
            }}
        </style>
    </head>
    <body>
        <h1>🚫 STOP! STOP! STOP! 🚫</h1>
        <p>{quote}</p>
        <form method="get" action="/">
            <button type="submit">Say it again 💅</button>
        </form>
    </body>
    </html>
    """)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)  # safer port
