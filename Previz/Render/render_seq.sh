#!/bin/bash
# render_seq.sh <SequenceAssetName e.g. SQ03_Pass1_Refusal> [preset=MRQ_Previz_HD]
# Renders one master sequence through Movie Render Queue in a separate -game process.
export MSYS_NO_PATHCONV=1
SEQ=$1; PRESET=${2:-MRQ_Previz_HD}
"/e/UnrealEngine/UE_5.8/Engine/Binaries/Win64/UnrealEditor.exe" "A:/MovieProjects/OneOfThem/OneOfThem.uproject" \
  /Game/OneOfThem/Maps/OOT_Previz_P -game \
  -LevelSequence="/Game/OneOfThem/Cinematics/$SEQ/OOT_$SEQ.OOT_$SEQ" \
  -MoviePipelineConfig="/Game/OneOfThem/Render/$PRESET.$PRESET" \
  -windowed -resx=1280 -resy=536 -log -notexturestreaming -unattended -nosplash \
  -abslog="A:/MovieProjects/OneOfThem/Saved/Logs/render_$SEQ.log"
