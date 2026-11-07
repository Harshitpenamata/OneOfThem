# Creates the basic HD previz render presets for Movie Render Queue:
# MRQ_Previz_HD (full sequence) and MRQ_Previz_HD_Test (short custom range).
import unreal

FOLDER = '/Game/OneOfThem/Render'
tools = unreal.AssetToolsHelpers.get_asset_tools()

def make(name, test_range=None):
    path = f'{FOLDER}/{name}'
    if unreal.EditorAssetLibrary.does_asset_exist(path):
        unreal.EditorAssetLibrary.delete_asset(path)
    cfg = tools.create_asset(name, FOLDER, unreal.MoviePipelinePrimaryConfig, unreal.MoviePipelinePrimaryConfigFactory())
    out = cfg.find_or_add_setting_by_class(unreal.MoviePipelineOutputSetting)
    out.output_directory = unreal.DirectoryPath('{project_dir}/Saved/MovieRenders/{sequence_name}')
    out.file_name_format = '{sequence_name}.{frame_number}'
    out.output_resolution = unreal.IntPoint(1920, 804)  # 2.39:1 HD
    out.zero_pad_frame_numbers = 5
    out.override_existing_output = True
    if test_range:
        out.use_custom_playback_range = True
        out.custom_start_frame, out.custom_end_frame = test_range
    cfg.find_or_add_setting_by_class(unreal.MoviePipelineDeferredPassBase)
    jpg = cfg.find_or_add_setting_by_class(unreal.MoviePipelineImageSequenceOutput_JPG)
    aa = cfg.find_or_add_setting_by_class(unreal.MoviePipelineAntiAliasingSetting)
    aa.spatial_sample_count = 1
    aa.temporal_sample_count = 1
    aa.engine_warm_up_count = 48   # rain needs ~2 s to fill before frame one
    aa.render_warm_up_count = 32
    aa.use_camera_cut_for_warm_up = False
    game = cfg.find_or_add_setting_by_class(unreal.MoviePipelineGameOverrideSetting)
    game.cinematic_quality_settings = True
    game.texture_streaming = unreal.MoviePipelineTextureStreamingMethod.FULLY_LOAD
    unreal.EditorAssetLibrary.save_loaded_asset(cfg)
    unreal.log(f'MRQCFG created {path}')

make('MRQ_Previz_HD')
make('MRQ_Previz_HD_Test', (1640, 1760))
