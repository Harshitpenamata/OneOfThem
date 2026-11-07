---
name: previz-cinematography
description: Shot-design rules for the One of Them previz in Unreal. Use whenever placing, framing, lensing, moving, focusing or lighting a camera or shot in Sequencer, reviewing a contact sheet or preview render, blocking a scene, or answering "how should this shot look". Covers shot size, angle, framing, composition, lens, focus, movement, rig emulation and motivated lighting, plus the exact numbers to turn those choices into Unreal camera transforms.
---

# Previz cinematography

Every camera in this film is a decision, not a placeholder. Before keying a camera, decide the seven specs below, write them down (in the shot's notes or your reply), then build and verify. The source material is StudioBinder's cinematography guides, distilled in `references/`.

## The seven specs (decide in this order)

1. **Story job** – what must the audience understand or feel in this shot? (one sentence)
2. **Shot size** – how much of the subject is in frame. See `references/shot-size-angle-framing.md`.
3. **Framing** – single, two-shot, OTS/dirty single, POV, insert. Same file.
4. **Angle and height** – eye, shoulder, hip, knee, ground, high, low, overhead, Dutch. Same file.
5. **Lens and focus** – focal length, deep vs shallow, rack. See `references/lens-focus.md`.
6. **Movement and rig** – static, pan, tilt, push, pull, track/truck, arc, boom, handheld, zoom, dolly-zoom, roll. Must be motivated. See `references/movement-rigs.md`.
7. **Composition and light** – thirds, lead room, headroom, balance, foreground, negative space; motivated key, contrast ratio, smart side vs dumb side. See `references/composition.md` and `references/lighting.md`.

## Non-negotiables

- **180° rule.** For any two-character exchange, define the line between them and keep all coverage on one side. Crossing is allowed only on a visible move (an arc that carries us across) or a deliberate disorientation beat.
- **Motivation.** Every move answers "why now?" (a character moves, looks, realises, a reveal is due). Otherwise lock off. Every light has a source the audience could believe.
- **Size contrast.** Hold the closest size for the most important moment in the scene. If everything is a close-up, nothing is.
- **POV sandwich.** Character looks → POV → character reacts.
- **Inserts carry information.** If an insert shows something a character does not notice, frame so the audience clearly gets it (dramatic irony).
- **Matched setups match exactly.** Reset masters and recurring inserts reuse the same transform, lens and height.

## Turning specs into Unreal numbers

The project filmback is Super 35 at 2.39:1, with a sensor of **24.89 × 10.41 mm**.

- **Camera distance for a given shot size:** `distance_cm = frame_height_cm × focal_mm / 10.41`, where frame height is the vertical slice of the subject the shot shows (table in `references/one-of-them-unreal.md`).
- **Horizontal field of view:** `2·atan(12.445 / f)`. For example, 24 mm → 54.8°, 35 mm → 39.1°, 50 mm → 27.9°, 75 mm → 18.8°, 100 mm → 14.2°.
- **Camera height** comes from the angle choice: Manny's eyes are at about 160 cm, shoulders about 145, hips about 95, knees about 50.
- **Aiming:** put the subject's eyes on the upper third line. In practice aim the camera about 10–15% of the frame height below the eyes, so there's headroom without crowding.
- **Two-shots and wide shots:** make sure both subjects fit inside the horizontal field of view at that distance. If they don't, re-stage the actors or change the lens; don't settle for an empty frame.

Full project mapping (characters, marks, lines of action, lighting rig, verification loop) is in `references/one-of-them-unreal.md`. **Read it before touching any One of Them shot.**

## Workflow

1. Read the shot row (description, angle, type) and the script beat.
2. Write the seven specs.
3. Compute the camera transform from the formulas, and check the 180° side and the occluders (wreck, trees, rocks) along the sightline.
4. Key the transform, focal length, aperture and focus distance. Key movement only with the motivation noted.
5. **Verify through the shot camera:** camera-cut lock on, `CaptureViewport` with `captureTransform: null`. Check that the subject reads, the size is right, the eyes are on a third, nothing blocks the view and it's exposed.
6. Fix, then re-verify. Only then move on.

When reviewing a contact sheet, run the same checklist per frame and name the failing spec ("S04-09: two-shot size impossible at 11 m separation, so re-stage or go wide").
