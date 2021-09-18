#
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--enable-extensions, default='', type=functools.partial(<function _flake8_normalize at 0x7ffff641a320>, comma_separated_list=True, normalize_paths=False), help='Enable plugins and extensions that are otherwise disabled by default')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--exit-zero, action='store_true', help='Exit with status code "0" even if there are errors.')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--install-hook, action=<class 'flake8.main.vcs.InstallAction'>, choices=['git', 'mercurial'], help='Install a hook that is run prior to a commit for the supported version control system.')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(-j, --jobs, default='auto', type=<class 'flake8.main.options.JobsArgument'>, help='Number of subprocesses to use to run checks in parallel. This is ignored on Windows. The default, "auto", will auto-detect the number of processors available to use. (Default: %(default)s)')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--tee, action='store_true', default=False, help='Write to stdout and output-file.')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--benchmark, action='store_true', default=False, help='Print benchmark information about this run of Flake8')".
# DEBUG    flake8.options.manager:manager.py:417 Registered option "Option(--bug-report, action=functools.partial(<class 'flake8.main.debug.DebugAction'>, option_manager=<flake8.options.manager.OptionManager object at 0x7ffff5b103d0>), nargs=0, help='Print information necessary when preparing a bug report')".
# DEBUG    flake8.options.config:config.py:338 Reading local plugins only from "tests/fixtures/config_files/local-plugin-path.ini" specified via --config by the user
# DEBUG    flake8.options.config:config.py:99 Found cli configuration files: ['tests/fixtures/config_files/local-plugin-path.ini']
# DEBUG    flake8.plugins.manager:manager.py:278 Loaded Plugin(name="XE", entry_point="aplugin:ExtensionTestPlugin2") for plugin "XE".
# INFO     flake8.plugins.manager:manager.py:253 Loading entry-points for "flake8.extension".
#
final: prev:
let packageOverrides = python-final: python-prev: {
  flake8 = python-prev.flake8.overrideAttrs (_: {
    doCheck = false;
  });
};
in
{
  #python = prev.python.override { inherit packageOverrides; };
  python37 = prev.python37.override { inherit packageOverrides; };
  python39 = prev.python39.override { inherit packageOverrides; };
}
