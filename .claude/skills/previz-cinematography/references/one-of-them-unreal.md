# One of Them: project mapping (read before touching any shot)

## Format

- **Frame:** 24 fps, 2.39:1. Filmback preset "OOT Super35 2.39" (24.89 × 10.41 mm), the project default.
- **Shot cameras:** spawnables named `CAM_<shot>` inside `OOT_<shot>` shot sequences under `/Game/OneOfThem/Cinematics/SQxx_*/SCxx/Shots/`.
- **Camera tracks:** the camera component binding is `CameraComponent`, with float tracks `CurrentFocalLength`, `ManualFocusDistance` and `CurrentAperture`. Key them at frame 0, channel name `None`.
- **Defaults:** aperture f/16; focus set to the subject distance.

## Shot size to distance (S35, subject = Manny, about 1.8 m)

Use `distance_cm = H × f / 10.41`, where H is the vertical slice of the frame.

| Size | H (cm) | 24 mm | 35 mm | 50 mm | 75 mm | 100 mm |
|---|---|---|---|---|---|---|
| ECU (eyes / lips) | 15 | 35 | 50 | 72 | 108 | 144 |
| CU (head + shoulders) | 35 | 81 | 118 | 168 | 252 | 336 |
| MCU (chest up) | 55 | 127 | 185 | 264 | 396 | 528 |
| MS (waist up) | 85 | 196 | 286 | 408 | 612 | — |
| Cowboy (mid-thigh) | 110 | 254 | 370 | 528 | — | — |
| MWS (knees up) | 130 | 300 | 437 | 624 | — | — |
| FS (head to toe + margin) | 220 | 507 | 740 | 1057 | — | — |
| WS | 450 | 1037 | 1513 | — | — | — |

- **Horizontal coverage at distance d:** width ≈ d × 24.89 / f. Two subjects separated by S fit only if S is less than about 0.8 × width.
- **Camera heights:** eye 160, shoulder 145, hip 95, knee 50, ground 15 to 25 cm. Kneeling Vikram's eyes are at about 95.
- **Aim point:** subject eyes minus about 0.12 × H, so the eyes land on the upper third.

## Characters, marks, sources (crash site, world cm)

- **Wreck:** `BP_CAR_Hero` at (2780, 120, 93), yaw 115, roll 84. It lies on the driver's side with the roof toward the foot of the slope. Local→world uses the axes AX, AY and AZ (see the scripts in the session history).
- **Vikram's mark at the foot of the slope:** (2050, 0). **Kneel point at the driver's window:** about (2606, 23).
- **Old Man:** OM1 at the beam edge, (2100, 1150). OM2, standing over the kneeling Vikram, about (2370, 56).
- **Light sources:**
  - Two wreck headlight spots, `BP_FX_WreckHeadlight` (1500 cd, beam toward −X+Y), switched by spawn tracks.
  - Moon, a blue directional light.
  - Sky light.
  - `BP_FX_PracticalFill`, a small cool fill for inserts and the dashboard glow.
  - The motivated practicals are the headlights, moon, phone screen and radio display. Nothing else.
- **Final night look (set 2026-10-25 from the director's reference):** dim, teal-cyan moonlight through heavy fog. Silhouettes always read, shadows are lifted, contrast is low and saturation is low. It is never pitch black. All of it lives in `LI_Light_Night`:

  | Element | Setting |
  |---|---|
  | Moon | intensity 4, colour (0.50, 0.85, 0.95) |
  | Sky light | intensity 3.5, colour (0.55, 0.80, 0.85); lower hemisphere (0.02, 0.05, 0.06) |
  | Height fog | density 0.05, falloff 0.35; inscatter (0.02, 0.07, 0.08); volumetric scattering distribution 0.6; albedo (0.8, 1, 1) |
  | `PPV_Night` | white balance 5000 K, saturation 0.7, contrast 0.92, gain (0.85, 1, 1), shadow offset (0, 0.004, 0.006); manual exposure bias 12.5 unchanged |

  Keep new lights motivated and inside this palette.
- **Rain:** `NS_OOT_Rain` in `BP_FX_Rain`. It freezes by keying `CustomTimeDilation` to 0, with a 2 s warm-up.

## Road geography (inside `LI_Set_CrashSite`, world cm)

- **Road:** a straight 7 m strip at x −350…350, top surface z 1000, running y −3000…3000; centre dashes at x 0. It ends at y ±3000, so keep lenses from seeing past y ≈ 2400 when looking along +Y.
- **Guardrail:** on the slope side at x 390. The torn gap runs y −690…40, with bent pieces at y −250 and 250.
- **Skid marks:** two arcs from (−160, −1600) to (300, −150), heading +Y into the gap. That means the crash car travelled +Y.
- **Slope:** from x 450 down to z 0 at x 2050, with `slope_z(x) = 1000 − (x − 450)·0.625`. The road lip at x 350–450 blocks low sightlines down the slope, so cameras behind the gap need z ≥ 1000 + 0.48·(450 − cam_x).
- **SC01/SC02 car:** travels −Y in the x −175 lane, with Bend A at y ≈ −1250. **SC03 run:** Vikram runs +Y (left to right, cameras on the −x forest side) and reaches the gap at (300, −340).

## Lines of action (180° rule)

- **Vikram ↔ Old Man at the crash site:** keep coverage on the clearing (+X) side of the line between them. The proven two-shot is from (3200, 1250, 170) at 24 mm. Cross only on the S07-28 orbit.
- **Car interior (SC01 / SC09):** right-hand drive. The driving axis runs along the road with Rohan on the right and Dev on the left. Keep the opening and return interiors on the same side.
- **Old Man at the driver's window (SC02 / SC08):** coverage from the road-centre side.

## Visual arc (use this to choose sizes, angles and moves per pass)

- **Pass 1, Refusal:** fragmented coverage with more cuts. Vikram is seen from slightly high angles while he panics and kneels (depowered); the Old Man is at eye level, static and centred, unchanging. Moves are reactive pans and follows.
- **Pass 2, Bargaining:** tighter. More MCUs and CUs, slow push-ins as Vikram bargains, and the "lips ahead" close two-shot. Vikram moves toward eye level.
- **Pass 3, The Wrong Name:** stillness. Longer static holds, more negative space around Vikram, and a matched reverse axis. Use an insert-led irony shot for the AMMA phone, which the audience sees and Vikram doesn't.
- **Pass 4, Faithful:** both men at eye level, a balanced symmetrical two-shot, the fewest cuts and longest takes. The first real push-in lands on "...No. Dev." The S07-28 arc / orbit is the only move that crosses the line, motivated by the reveal.
- **Return (SQ07):** mirror the opening setups exactly (matched-shot list), with one held CU on Vikram's smile.

## Old Man coverage grammar (director's reference: Travis Scott in *The Odyssey*, set 2026-10-26)

- **Staff:** he always holds `BP_PROP_Staff` (165 cm, wood). It's a spawnable attached to his Body at socket `hand_l` (snap to target), relative location 0, relative rotation (pitch 15.03, yaw −129.79, roll −112.88). That rotation was solved to cancel the idle hand rotation, so the staff stands upright. Its spawn keys are copied from his.
- **Strike:** a layered `CR_Mannequin_Body` track on OldMan, lift pose `upperarm_l_fk_ctrl.Rotation.Y` 20, `lowerarm_l_fk_ctrl.Rotation.Z` 70, `hand_l_fk_ctrl.Rotation.X` 7 / `.Y` −82. That raises the hand 29 cm with the staff within 1° of upright. Key it 0 → lift (8 f) → 0 (6 f).
- **Sound:** SFX beds come from `Assets/Sounds` via `Previz/Tools/sfx_mix.sh` and the `Previz/Sound/SQxx_sfx.txt` cue sheets. The radio song cuts on a half-word at 25.4 s into `Song_On_Radio`.
- **Close:** 85mm f/2.8, 4 m, camera at 135 cm (slightly below his eyes), 25° off his eyeline toward Vikram. Head and shoulders, with the staff top beside his face.
- **Mid:** 50mm f/4, 4.7 m, camera at 125 cm, 35° off his eyeline. Waist-up from slightly below.
- **Wide:** 24mm f/8, 4.3 m, camera at 35 cm off the ground, 40° off his eyeline. Low, monumental full figure with the staff upright.
- **Side and key:** cameras stay on the +X side of the Old Man–Vikram line. His hard side key is `FX_OMKey` (`BP_FX_OMKey`, 150 cd, 22° cone), attached to him at relative (150, −150, 230).
- **Rejection beat:** at the end of Passes 1–3, just before the radio ending:

  | Shot | Length | Content |
  |---|---|---|
  | B | 48 f | 40mm mid-close (hand and staff in frame): "Not this one." (P1, P2) or "Not him." (P3); strike one at f41 |
  | C | 16 f | Low wide; strike two on its last frame |
  | D | 24 f | Black |

## Matched setups (copy transform, lens and height)

- **Reset master:** S04-01 = S05-01 = S06-01 = S07-01.
- **Radio insert:** S04-17 = S05-17 = S06-21.
- **Frozen rain wide:** S04-18 = S05-18 = S06-22.
- **Vikram's phone:** S04-05 = S05-04.
- **AMMA phone:** S06-15 = S06-18 = S07-18.
- **Dashboard clock:** S01-02 = S09-01 = S09-07.
- **Interior master:** S01-01 = S09-02.
- **Headlight reveal:** S01-08 = S08-01.
- **Puddle:** S02-01 = S08-02.

## Verification loop (proven in this project)

1. Open the SQ sequence, set the camera lock on with `set_camera_lock {lock:true}`, set the playhead and force an evaluate.
2. Capture with `EditorAppToolset.CaptureViewport` and `{captureTransform:null, annotations:null, bShowUI:false}`. This renders through the shot camera.
3. Write the base64 with `AssetTools.write_file` to `Saved/PrevizFrames/*.txt`, decode it locally, then look.
4. **After any Level Instance edit, reload `OOT_Previz_P`** before capturing. Otherwise the viewport stays grey and desaturated and ignores the post-process volume.
5. Check for occluders (trees, rocks, wreck) along every sightline before keying.

Delete or move offenders inside the `LI_Set_CrashSite` edit, then commit and reload.

## HD render (Movie Render Queue)

- **Presets:** `/Game/OneOfThem/Render/MRQ_Previz_HD` (1920×804 JPEG, cinematic quality, 48-frame engine warm-up for the rain) and `MRQ_Previz_HD_Test` (frames 1640–1760). Rebuild them with `Previz/Render/make_mrq_config.py` through `UnrealEditor-Cmd -run=pythonscript`.
- **Render:** `Previz/Render/render_seq.sh <SQ folder name>` renders one master in a separate `-game` process to `Saved/MovieRenders/OOT_<SQ>/`. Save the editor first. It needs `MSYS_NO_PATHCONV=1`, or Git Bash mangles `/Game/` paths.
- **Black shots** (no camera cut) are skipped by MRQ. Fill those frame numbers with `Saved/MovieRenders/black.jpeg` before encoding.
- **Encode:** `Previz/Render/encode_hd.sh <ver> <reel ver>` muxes with `Previz/Sound/SQxx_full_mix.wav` into `Previz/Renders/HD/`.
- **Character `NameTag` text** is hidden in game on all `BP_CH_*`; keep it that way for new characters.

## Gotchas

- **Spawnable tracks:** add a spawnable only while its sequence is open in Sequencer, and only after its Blueprint has compiled.
- **Empty duplicate sections:** a new spawnable gets an auto transform track. Reuse that track's section; an empty duplicate section blends to half the values.
- **Auto Control Rig tracks** on Manny "Body" bindings override the animation clips. Remove them, or use them in layered mode.
- **Niagara enums:** never change them with `SetStackInputData`, because it crashed the editor. Plain float or HLSL inputs are safe.
- **Hidden-in-game actors:** marks are hidden in game. Editor sprites still show in viewport captures.
- **Aperture changes exposure:** `PPV_Night` uses physical-camera exposure calibrated at f/16 (bias 12.5). Opening up brightens the shot (f/2.8 is about +5 stops). Whenever a shot camera uses an aperture other than f/16, add two tracks on its `CameraComponent` binding:
  - a float property track `PostProcessSettings.AutoExposureBias` set to `12.5 − 2·log2(16/N)`, for example 7.47 at f/2.8, 8.5 at f/4, 9.47 at f/5.6 and 10.5 at f/8;
  - a bool track `PostProcessSettings.bOverride_AutoExposureBias` set to true.
- **Shallow focus defaults (Pass 3 onward):**
  - Close singles at f/2.8, with focus on the eyes (distance from the camera to the eyes, not to the aim point).
  - Two-shots at f/5.6, inserts at f/4, POVs and wides at f/8.
  - Matched masters copied from Pass 1 stay at f/16.
- **Viewport size changes between editor sessions** (1307 then 1704 px wide). Before stamping, fit captures to 1306 × 690 with a 2.39:1 crop so all passes match.
