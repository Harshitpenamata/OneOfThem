# Lighting

Distilled from StudioBinder's film lighting guide. These are paraphrased notes.

## Sources and approach

- **Natural** (sun, moon, fire) and **artificial** (practicals, film lights).
- **Ambient** – light the crew didn't bring (a passing car's headlights, a neon sign).
- **Practical** – a source visible in frame (a lamp, headlight, phone screen, radio display).
- **Motivated lighting** – an approach, not a fixture: every light on the subject has a believable in-world reason, even when the real light is a hidden fixture placed off frame.

## Measures

- **Strength** – lumens at the source; lux or foot-candles of incident light reaching the subject; reflected light reaching the lens.
- **Falloff follows the inverse square law** (intensity ∝ 1/distance²). Move a light, not just its dimmer, to shape the falloff.
- **Colour temperature** in Kelvin: tungsten is about 3200 K (warm), daylight about 5600 K (cool). Moonlight is conventionally played bluer than the practicals; warm interiors against blue exteriors gives contrast.
- **Exposure** – over means washed-out highlights, under means crushed shadows; controlled with aperture, shutter and ISO (or Unreal exposure bias).

## Looks

- **High key** – a low contrast ratio, mostly soft light. Comfortable, open.
- **Low key / chiaroscuro** – a high contrast ratio, hard light, deep shadows. Mystery, threat, noir.
- **Hard vs soft** – hard light means crisp shadows; soft (diffused) light means gentle falloff.
- **Dumb side / broad lighting** – the key lights the side of the face toward the camera. Easy, reassuring.
- **Smart side / short lighting** – the key lights the side away from the camera. Dramatic; a near silhouette is scary.
- **Edge / back light** – separates the subject from the background.
- **Flares and bokeh** – a light hitting the lens, or out-of-focus practicals. Use them as style accents.
- **Natural diffusers** – fog, smoke, clouds, rain soften and reveal beams.

## Tools, and their Unreal equivalents

Gels → Light Color or Temperature. Diffusion / softbox → Source Radius and Soft Source Radius. Flags and barn doors → spot cone angles plus light functions or blockers. ND → Intensity. Cookie → Light Function material. Bounce → a low-intensity fill light from the bounce direction. Fog, smoke, rain → Exponential Height Fog with volumetrics plus a per-light Volumetric Scattering Intensity.
