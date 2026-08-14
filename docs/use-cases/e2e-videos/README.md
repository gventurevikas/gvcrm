# GVCRM End-to-End Journey Videos (human-like voice)

**11 narrated MP4 walkthroughs** with **neural TTS** and **detailed demo scripts**.

| Improvement | Detail |
|-------------|--------|
| Voice | Microsoft **en-US-AvaNeural** via `edge-tts` (warm, conversational — not macOS `say`) |
| Pace | Slightly slower (`-12%`) with short fades between lines |
| Script | Full product-demo narration per screen (why it matters, not just labels) |
| Sync | Each screen holds until that spoken line finishes |
| Transcripts | Matching `E2E-UC-NNN-transcript.txt` beside each video |

> UX storyboard walkthroughs from mocks + neural voiceover — not live product recordings.

Source journeys: [`../00-end-to-end-journeys.md`](../00-end-to-end-journeys.md).

---

## Videos

| File | Journey | Duration (approx) |
|------|---------|-------------------|
| [E2E-UC-001.mp4](./E2E-UC-001.mp4) | Meta lead → first touch | ~2:21 |
| [E2E-UC-002.mp4](./E2E-UC-002.mp4) | Lead convert → household → quote | ~2:09 |
| [E2E-UC-003.mp4](./E2E-UC-003.mp4) | Renewal book management | ~1:24 |
| [E2E-UC-004.mp4](./E2E-UC-004.mp4) | Discount approval on quote | ~1:06 |
| [E2E-UC-005.mp4](./E2E-UC-005.mp4) | Homepage, report & leaderboard | ~1:36 |
| [E2E-UC-006.mp4](./E2E-UC-006.mp4) | Collaborate on a stuck deal | ~1:19 |
| [E2E-UC-007.mp4](./E2E-UC-007.mp4) | Assistant operates as the user | ~1:26 |
| [E2E-UC-008.mp4](./E2E-UC-008.mp4) | Marketplace sandbox → production | ~1:10 |
| [E2E-UC-009.mp4](./E2E-UC-009.mp4) | Platform customize and promote | ~1:10 |
| [E2E-UC-010.mp4](./E2E-UC-010.mp4) | Carrier wholesaler view | ~0:59 |
| [E2E-UC-011.mp4](./E2E-UC-011.mp4) | Secure account (SMS + Authenticator) | ~1:31 |

Transcripts: `E2E-UC-001-transcript.txt` … `E2E-UC-011-transcript.txt`.

---

## Play

```bash
open docs/use-cases/e2e-videos/E2E-UC-001.mp4
```

---

## Rebuild / alternate voices

```bash
./docs/use-cases/e2e-videos/rebuild-narrated.sh

# Other neural options
VOICE=en-US-JennyNeural RATE=-10% ./docs/use-cases/e2e-videos/rebuild-narrated.sh
VOICE=en-US-AndrewNeural RATE=-8% ./docs/use-cases/e2e-videos/rebuild-narrated.sh
```

Edit spoken copy inside [`rebuild-narrated.sh`](./rebuild-narrated.sh) (text next to each mock image path).

Requires network once for `edge-tts` synthesis. Local venv: `.tts-venv/` (gitignored).

---

## Voice quality note

| Engine | Feel |
|--------|------|
| macOS `say` (Samantha) — previous | Robotic / classic TTS |
| **edge-tts AvaNeural — current** | Much more human, conversational demo narrator |

For studio-grade talent later, swap the `speak()` function to ElevenLabs / OpenAI TTS using the same transcript files.
