# Camera movement and rigs

Distilled from StudioBinder's guides on camera movement and camera rigs. These are paraphrased notes.

## Movement (what it is – when it earns its place)

- **Static / locked off** – the actors move, the camera doesn't. Best for performance, precise composition and shot–reverse-shot. A static scene makes a single later move feel enormous.
- **Pan** – horizontal swivel. Follows action, reveals new information, adjusts framing. **Whip pan** = a fast pan that connects two subjects with energy instead of a cut.
- **Tilt** – vertical swivel. Scale, dominance, awe, revealing height.
- **Push in** – camera moves toward the subject (dolly or Steadicam). Tension, intimacy, the audience reading a character's inner shift. Even a few percent reads as a big moment after stillness.
- **Pull out** – camera moves away. Reveals context; isolates or detaches the character; can foreshadow.
- **Zoom** – the focal length changes and the camera stays put. It feels artificial because the eye can't zoom, so it suits unease, horror and thrillers. Use it rarely and deliberately.
- **Dolly zoom (vertigo)** – push while zooming out, or the reverse. The subject stays the same size while the background warps. Internal turmoil, the supernatural, a reality shift.
- **Roll** – rotate around the lens axis. Dizziness, instability, power slipping. Use only when you want discomfort.
- **Tracking / truck** – the camera travels with a moving subject (a truck is lateral). Immersion, fluid following, long takes.
- **Arc** – the camera circles the subject. Energy, menace or heightened emotion around a static performance.
- **Boom / crane** – vertical travel, small or large. Reveals, establishing scale, or rising away from a character for helplessness or isolation.
- **Handheld** – operator shake. Documentary rawness, subjectivity, chaos, intimacy; it can distract if unmotivated.
- **Bird's eye moves** – an overhead travel for an omniscient view.

Every move needs a trigger: a character's motion or look, a reveal, an emotional turn. If you can't name it, lock off.

## Rigs, and how to fake each one in Unreal

| Rig | Character of the move | Unreal keyframing equivalent |
|---|---|---|
| Tripod | Static; smooth pan and tilt only | Location constant; rotation keys only; cubic ease |
| Pedestal | Small vertical rises or drops for reveals | Z-only keys, slow ease |
| Dolly / slider | Smooth straight pushes, pulls and trucks; can start and stop on a precise frame | Linear path on 1–2 axes, ease in and out, no roll |
| Crane / jib | Large arcing vertical and horizontal moves | Z plus an arc in XY, long eases; or the Unreal Camera Rig Crane actor |
| Steadicam / gimbal | Floating long takes, follows anywhere | Smooth spline path, slight lag behind the subject, tiny drift |
| Handheld / shoulder | Organic shake, reactive reframes | Add low-amplitude noise (about 0.3–1° rotation, 1–2 cm position) on top of the path |
| Overhead mount | Straight down | Pitch −90°, high Z |
| Vehicle mount | Rides with the car | Attach the camera to the car's binding (Attach track) |
| Drone / aerial | High sweeping establishers | High Z, long linear travel, gentle yaw |
| Snorricam | Body-locked, background swings | Attach to the character's head or chest socket |
| Motion control | Exact repeat of a move | Copy the same keys between shots (use this for the reset passes) |

Lenses for movement: wide lenses make dolly and tracking moves feel faster and smoother; long lenses magnify shake.
