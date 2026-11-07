# Ripple-delete frame ranges from a pass: its scene anim sequence, its SQ master (shots, anim sub-track,
# audio) and the trimmed shots' own ranges. Run through ProgrammaticToolset.execute_tool_script after
# replacing the three CONFIG lines. Keys inside a cut are clamped to the cut start (last key wins).
import json
S = 'animation_toolset.toolsets.sequencer.SequencerTools.'
K = 'animation_toolset.toolsets.keyframing.SequencerKeyframingTools.'
O = 'editor_toolset.toolsets.object.ObjectTools.'

ANIM = '__ANIM__'      # CONFIG: anim sequence object path
MASTER = '__MASTER__'  # CONFIG: SQ master object path
CUTS = __CUTS__        # CONFIG: [(start, end), ...] in SQ frames, end exclusive


def t(n, a, p=S):
    return execute_tool(p + n, json.dumps(a))['returnValue']


def fmap(f):
    out = f
    for a, b in CUTS:
        if f >= b:
            out -= (b - a)
        elif f >= a:
            out -= (f - a)
    return out


def rng(sec):
    if t('has_section_start_frame', {'section': sec}) and t('has_section_end_frame', {'section': sec}):
        return json.loads(t('get_section_range', {'section': sec}))
    return None


def remap_keys(sec, is_bool, interp):
    moved = 0
    for ch in t('get_channel_names', {'section': sec}, K):
        keys = json.loads(t('get_keys', {'section': sec, 'channel_name': ch}, K))
        if not keys or all(fmap(k['frame']) == k['frame'] for k in keys):
            continue
        new = {}
        for k in sorted(keys, key=lambda k: k['frame']):
            new[fmap(k['frame'])] = k['value']
        for k in keys:
            t('remove_key_at_frame', {'section': sec, 'channel_name': ch, 'frame': k['frame']}, K)
        for f, v in sorted(new.items()):
            if is_bool:
                t('add_key_bool', {'section': sec, 'channel_name': ch, 'frame': f, 'value': bool(v)}, K)
            else:
                t('add_key_float', {'section': sec, 'channel_name': ch, 'frame': f, 'value': v, 'interpolation': interp}, K)
        moved += 1
    return moved


def run():
    anim = {'refPath': ANIM}
    master = {'refPath': MASTER}
    total = sum(b - a for a, b in CUTS)
    log = {'channels': 0}
    t('open_sequence', {'sequence': anim})
    for b in t('get_bindings', {'sequence': anim}):
        name = t('get_binding_name', {'binding': b})
        for tr in t('get_tracks_on_binding', {'binding': b}):
            r = tr['refPath']
            interp = 'constant' if (name == 'FX_Rain' and 'FloatTrack' in r) else ''
            for sec in t('get_sections', {'track': tr}):
                rr = rng(sec)
                if rr:
                    t('set_section_range', {'section': sec, 'start_frame': fmap(rr['start']), 'end_frame': fmap(rr['end'])})
                log['channels'] += remap_keys(sec, 'SpawnTrack' in r, interp)
    pr = json.loads(t('get_playback_range', {'sequence': anim}))
    t('set_playback_range', {'sequence': anim, 'start_frame': 0, 'end_frame': pr['end'] - total})
    t('close_sequence', {})
    t('open_sequence', {'sequence': master})
    shots = []
    for tr in t('get_tracks_on_sequence', {'sequence': master}):
        r = tr['refPath']
        for sec in t('get_sections', {'track': tr}):
            rr = rng(sec)
            if not rr:
                continue
            if 'CinematicShotTrack' in r or 'SubTrack' in r:
                ns, ne = fmap(rr['start']), fmap(rr['end'])
                t('set_section_range', {'section': sec, 'start_frame': ns, 'end_frame': ne})
                if 'CinematicShotTrack' in r and (ne - ns) != (rr['end'] - rr['start']):
                    shots.append([sec, ne - ns])
            elif 'AudioTrack' in r:
                ns = fmap(rr['start'])
                t('set_section_range', {'section': sec, 'start_frame': ns, 'end_frame': ns + rr['end'] - rr['start']})
    pr = json.loads(t('get_playback_range', {'sequence': master}))
    t('set_playback_range', {'sequence': master, 'start_frame': 0, 'end_frame': pr['end'] - total})
    # shorten each trimmed shot's own playback range and camera cut
    for sec, length in shots:
        sub = json.loads(t('get_properties', {'instance': sec, 'properties': ['subSequence']}, O))['subSequence']
        t('set_playback_range', {'sequence': sub, 'start_frame': 0, 'end_frame': length})
        for tr in t('get_tracks_on_sequence', {'sequence': sub}):
            if 'CameraCut' in tr['refPath'] or 'Fade' in tr['refPath']:
                for s in t('get_sections', {'track': tr}):
                    if rng(s):
                        t('set_section_range', {'section': s, 'start_frame': 0, 'end_frame': length})
    log['shots_trimmed'] = len(shots)
    log['new_length'] = pr['end'] - total
    return log
