import os
import ConfigParser

def add_config_option(config, section, option, value):
    if not config.has_section(section):
        config.add_section(section)
    config.set(section, option, value)

inFileName = 'python/MPAS-Analysis/config.analysis'
outFileName = 'config.ocnice'

config = ConfigParser.RawConfigParser()
config.read(inFileName)

add_config_option(config, 'case', 'casename', os.environ['test_casename'])
add_config_option(config, 'case', 'native_res', os.environ['test_native_res'])
add_config_option(config, 'case', 'short_term_archive', os.environ['test_short_term_archive'])
add_config_option(config, 'case', 'ref_casename_v0', os.environ['ref_case_v0'])

add_config_option(config, 'paths', 'archive_dir', os.environ['test_archive_dir'])
add_config_option(config, 'paths', 'archive_dir_ocn', os.environ['archive_dir_ocn'])
add_config_option(config, 'paths', 'scratch_dir', os.environ['test_scratch_dir'])
add_config_option(config, 'paths', 'plots_dir', os.environ['plots_dir'])
add_config_option(config, 'paths', 'log_dir', os.environ['log_dir'])
add_config_option(config, 'paths', 'obs_ocndir', os.environ['obs_ocndir'])
add_config_option(config, 'paths', 'obs_sstdir', os.environ['obs_sstdir'])
add_config_option(config, 'paths', 'obs_seaicedir', os.environ['obs_seaicedir'])
add_config_option(config, 'paths', 'ref_archive_v0_ocndir', os.environ['ref_archive_v0_ocndir'])
add_config_option(config, 'paths', 'ref_archive_v0_seaicedir', os.environ['ref_archive_v0_seaicedir'])

add_config_option(config, 'data', 'mpas_meshfile', os.environ['mpas_meshfile'])
add_config_option(config, 'data', 'mpas_remapfile', os.environ['mpas_remapfile'])
add_config_option(config, 'data', 'pop_remapfile', os.environ['pop_remapfile'])
add_config_option(config, 'data', 'mpas_climodir', os.environ['mpas_climodir'])

add_config_option(config, 'seaIceData', 'obs_iceareaNH', os.environ['obs_iceareaNH'])
add_config_option(config, 'seaIceData', 'obs_iceareaSH', os.environ['obs_iceareaSH'])
add_config_option(config, 'seaIceData', 'obs_icevolNH', os.environ['obs_icevolNH'])
add_config_option(config, 'seaIceData', 'obs_icevolSH', os.environ['obs_icevolSH'])

add_config_option(config, 'time', 'climo_yr1', os.environ['test_begin_yr_climo'])
add_config_option(config, 'time', 'climo_yr2', os.environ['test_end_yr_climo'])
add_config_option(config, 'time', 'yr_offset', os.environ['yr_offset'])

add_config_option(config, 'ohc_timeseries', 'generate', os.environ['generate_ohc_trends'])

add_config_option(config, 'sst_timeseries', 'generate', os.environ['generate_sst_trends'])

add_config_option(config, 'nino34_timeseries', 'generate', os.environ['generate_nino34'])

add_config_option(config, 'mht_timeseries', 'generate', os.environ['generate_mht'])

add_config_option(config, 'moc_timeseries', 'generate', os.environ['generate_moc'])

add_config_option(config, 'sst_modelvsobs', 'generate', os.environ['generate_sst_climo'])

add_config_option(config, 'seaice_timeseries', 'generate', os.environ['generate_seaice_trends'])

add_config_option(config, 'seaice_modelvsobs', 'generate', os.environ['generate_seaice_climo'])

filePointer = open(outFileName, 'w')
config.write(filePointer)
filePointer.close()
