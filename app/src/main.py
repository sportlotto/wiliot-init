from datetime import datetime
from flask import Flask
from pytz import timezone

app = Flask(__name__)


@app.route("/")
def index():
    return (
           f"""<table>
                 <thead>
                   <tr>
                     <th colspan="2">Current time for different places</th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>Tokyo</td>
                     <td>{datetime.now(tz=timezone('Asia/Tokyo')).strftime('%H:%M:%S %d/%b/%Y')}</td>
                   </tr>
                   <tr>
                     <td>Berlin</td>
                     <td>{datetime.now(tz=timezone('Europe/Berlin')).strftime('%H:%M:%S %d/%b/%Y')}</td>
                   </tr>
                   <tr>
                     <td>New York</td>
                     <td>{datetime.now(tz=timezone('America/New_York')).strftime('%H:%M:%S %d/%b/%Y')}</td>
                   </tr>
                 </tbody>
               </table>"""
    )


@app.route("/health")
def health():
    return dict(status=200)
    

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)

