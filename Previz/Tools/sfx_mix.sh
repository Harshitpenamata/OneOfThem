#!/bin/bash
# Builds a sound-effects bed for one sequence from Assets/Sounds and mixes it under the dialogue mix.
# Usage: sfx_mix.sh <spec file> <length seconds> <dialogue wav> <out wav>
# Spec lines: name|start_frame|end_frame|src_offset_s|gain_db|extra_filters|fade_in_s|fade_out_s
#   name is a key from SRC below; end_frame is exclusive; lines starting with # are ignored.
FF="/c/Users/hi/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.1.2-full_build/bin/ffmpeg.exe"
S="/a/MovieProjects/OneOfThem/Assets/Sounds"
declare -A SRC=(
  [interior]="$S/arunangshubanerjee-loopable-car-interior-driving-with-wipers-in-rain-366316.mp3"
  [forest]="$S/eryliaa-night-forest-with-frogs-and-crickets-for-sleep-451153.mp3"
  [crash]="$S/freesound_community-car-accident-with-squeal-and-crash-6054.mp3"
  [hazard]="$S/freesound_community-car-emergency-lights-01-74715.mp3"
  [static]="$S/freesound_community-fm-radio-static-82334.mp3"
  [steps]="$S/morganfilm-walking-fast-in-water-168151.mp3"
  [rain]="$S/rain.mp3"
  [song]="$S/Song_On_Radio.weba"
  [engine]="$S/spinopel-car-engine-noise-321224.mp3"
  [strike]="$S/StickStrike.mp3"
)
spec=$1; len=$2; dlg=$3; out=$4
ins=(); flt=""; n=0
while IFS='|' read -r name a b off gain extra fi fo; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  dur=$(awk "BEGIN{printf \"%.3f\", ($b-$a)/24}")
  ms=$(( a*1000/24 ))
  ins+=(-stream_loop -1 -i "${SRC[$name]}")
  chain="[$n:a]aresample=48000,aformat=channel_layouts=stereo,atrim=${off}:$(awk "BEGIN{print $off+$dur}"),asetpts=PTS-STARTPTS"
  [[ -n "$extra" ]] && chain="$chain,$extra"
  [[ "$fi" != "0" && -n "$fi" ]] && chain="$chain,afade=t=in:d=$fi"
  [[ "$fo" != "0" && -n "$fo" ]] && chain="$chain,afade=t=out:st=$(awk "BEGIN{print $dur-$fo}"):d=$fo"
  chain="$chain,volume=${gain}dB,adelay=${ms}|${ms}[s$n];"
  flt="$flt$chain"; n=$((n+1))
done < "$spec"
mixin=""; for i in $(seq 0 $((n-1))); do mixin="$mixin[s$i]"; done
ins+=(-i "$dlg")
flt="$flt${mixin}amix=inputs=$n:normalize=0:duration=longest,apad=whole_dur=$len,atrim=0:$len[sfx];[$n:a]aresample=48000,aformat=channel_layouts=stereo[dx];[dx][sfx]amix=inputs=2:normalize=0:duration=first,alimiter=limit=0.95[out]"
"$FF" -y -hide_banner -loglevel error "${ins[@]}" -filter_complex "$flt" -map "[out]" -c:a pcm_s16le "$out" && echo "$out: $n sfx layers"
