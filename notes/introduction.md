# LLM als OCR software

Willkommen zum Workshop!  
In dieser Sitzung testen wir verschiedene **OCR- und HTR-Systeme** und vergleichen sie direkt in einer **RENKU-Umgebung**.  
Besonderer Fokus liegt auf der Nutzung von **Vision-Language-Models (VLMs)** wie z. B. ChatGPT oder Mistral.



## Kursziele

- **OCR/HTR kennenlernen** – verstehen, wie Texterkennung mit Handschriften und Scans funktioniert  
- **VLMs ausprobieren** – sehen, wie Modelle über eine API für OCR genutzt werden können  
- **CER (Character Error Rate) anwenden** – eine zentrale Metrik für Genauigkeit kennenlernen  
- **Python als Werkzeug erleben** – entdecken, dass man mit wenigen Schritten produktiv arbeiten kann  
- **Austausch mit anderen** – erleben, dass es eine Community mit ähnlichen Interessen gibt

## Ablauf (90 Minuten)

1. **Einführung**: Überblick zu OCR/HTR
2. **Demo**: RENKU-Umgebung kopieren und erste Tests
3. **Experiment 1**: OCR mit Beispielbildern und CER-Berechnung  
4. **Experiment 2**: Eigene Daten hochladen und ausprobieren  
5. **Vergleich**: Ergebnisse aus Gruppen oder Einzelarbeit  
6. **Abschluss**: Kurzes Teilen von Erfahrungen, offene Diskussion 


## Kurze Geschichte von OCR

| Jahr | Ereignisse |
|------|------------|
| __1870__ |  Erfindung Retina Scanner von Charles R. Carey |
| __1913__ | Erfindung von Optophone von Edmund Fournier d'Albe. Optophone ist ein Gerät, das die Schriftzeichen in Tönen verwandelt
![](./img/optophone.jpg)
![](./img/tone_generation.png) |
| __1931__ |  Patentierung von Statistical machine (Gerät zur fotooptischen Datenabfrage in der Mikrofilmtechnik) von Emanuel Goldberg ([US000001838389A](https://patents.google.com/patent/US1838389)) |
| __1951__ | Erfindung von [Gismo](https://patents.google.com/patent/US2663758A/en) (Patentierung 1953) von David Hammond Shepard. Gismo konnte gedruckte Schriftzeichen oder Morsecode in andere unterschiedliche Codierung umwandeln  |
| __1952__ | Shepard gründete die Firma "The Intelligent Machines Research Corporation" mit William Lawless Jr. und kommerzialisierte seine Erfindung |
| __1974__ | Ray Kurzweil erfand die erste "omni-font" OCR-Software |
| __1993__ | First release von ABBYY FineReader |
| __2005__ | "[Tesseract](https://github.com/tesseract-ocr/tesseract)" ist als Open Source Software freigegeben. Tesseract wurde urspürnglich von Hewlett-Packard zwischen 1984 und 1994 entwickelt |
| __2022__ | [Donut (Document Understanding Transformer)](https://github.com/clovaai/donut) ist bekannt gegeben. Donut ist ein "OCR-free end-to-end Transformer model", das doch Dokumente klassifizieren und Information aus Dokumente extrahieren kann |
| __2023/2024 ?__ | VLMs (Vision-Language-Modelle) werden auch als OCR eingesetzt[^1] |
| __2025 März__ | [MistralOCR](https://mistral.ai/news/mistral-ocr) released  |



[^1]: Lamm, Bianca, und Janis Keuper. „Can Visual Language Models Replace OCR-Based Visual Question Answering Pipelines in Production? A Case Study in Retail“. arXiv, 28. August 2024. (Preprint) https://doi.org/10.48550/arXiv.2408.15626.



## OCR Time Machine

[Daniel van Strien](https://danielvanstrien.xyz/) hat neulich "OCR Time Machine" auf der Plattform Huggingface publiziert:

https://huggingface.co/spaces/davanstrien/ocr-time-machine

__Beschreibung von OCR Time Machine__
>Travel through time to see how OCR technology has evolved!
>
>For decades, galleries, libraries, archives, and museums (GLAMs) have used Optical Character Recognition to transform digitized books, newspapers, and manuscripts into machine-readable text. Traditional OCR produces complex XML formats like ALTO, packed with layout details but difficult to use. Now, cutting-edge Vision-Language Models (VLMs) are revolutionizing OCR with simpler, cleaner Markdown output. This Space makes it easy to compare these two approaches and see which works best for your historical documents. Upload a historical document image and its XML file to compare these approaches side-by-side. We'll extract the reading order from your XML for an apples-to-apples comparison of the actual text content.

Wie Daniel beschreibt, funktioniert viele VLMs heute als gute OCR-Software.
Ausser solcher VLM-Modelle versuchen wir auch andere OCR-Software/Dienstleistungen, die traditionelle OCR-Verfahren haben.


## OCR-Funktionen testen

### OCR-Software, die wir heute ausprobieren

- Tesseract
- Google Cloud Vision API

__VLMs__

- MistralOCR
- GPT-4.1
- Gemini

## Qualitätsmessung 

Um die Qualität der OCR-Software/Dienstleistung sichtbar zu machen, wird CER (Character Error Rate) häufig verwendet.

Wir verwenden das Python-Paket **jiwer**, um die Genauigkeit der OCR/HTR-Ergebnisse zu berechnen.

Im Fokus steht die **Character Error Rate (CER)**, zusätzlich kann auch die **Word Error Rate (WER)** berechnet werden.

CER berechnet man folgendermassen:

CER (Character Error Rate) und WER (Word Error Rate)

__CER__

```math
(S + D + I) / N = (S + D + I) / (S + D + C)
````

- S ist die Anzahl der Ersetzungen
- D ist die Anzahl der Streichungen
- I ist die Anzahl der Einfügungen
- C ist die Anzahl der richtigen Zeichen
- N ist die Anzahl der Zeichen in der Referenz $`(N=S+D+C)`$

Bei Python gibt es verschiedene Libraries wie [jiwer](https://jitsi.github.io/jiwer/) oder [evaluate](https://github.com/huggingface/evaluate) für diesen Zweck.


__WER__

```math
(S + D + I) / N = (S + D + I) / (S + D + C)
````
- S ist die Anzahl der Ersetzungen
- D ist die Anzahl der Streichungen
- I ist die Anzahl der Einfügungen 
- C ist die Anzahl der richtigen Wörter 
- N ist die Anzahl der Wörter in der Referenz $`(N=S+D+C)`$


## Anhang: Weitere Evaluationsmetriken

Neben dem **CER (Character Error Rate)**, das wir im Kurs verwenden, gibt es weitere gebräuchliche Metriken:

- **F-Score (F1-Score)**
  Kombiniert **Precision** (Anteil der korrekt erkannten Elemente unter allen erkannten) und **Recall** (Anteil der korrekt erkannten Elemente unter allen relevanten).
  Besonders bei der Worterkennung wird der F-Score oft verwendet.

👉 Im Kurs konzentrieren wir uns auf CER, aber für weiterführende Analysen können WER und F-Score sehr hilfreich sein.

Mit Python und `scikit-learn` lässt sich der F-Score leicht berechnen:

```python
from sklearn.metrics import f1_score

# y_true: Liste der wahren Labels
# y_pred: Liste der vom Modell erkannten Labels
f1 = f1_score(y_true, y_pred, average="macro")
print("F1-Score:", f1)
```


## Weiterführende Themen

### Weitere Modelle 



- [Text Titan I ter (Juli 2025/ Transkribus)](https://blog.transkribus.org/en/new-text-titan-i-ter-and-how-it-compares-to-chatgpt-gemini-and-other-llms)
- [Donut](https://github.com/clovaai/donut)
- [GOT-OCR2.0]()